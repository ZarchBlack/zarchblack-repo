#!/usr/bin/env python3
# ===================================================================
# ZarchBlack Repository Sign and Upload Automation Script
# Signs packages, updates db, and uploads new assets/signatures to GH Releases.
# ===================================================================
import os
import sys
import glob
import subprocess
import urllib.request
import urllib.parse
import urllib.error
import json

REPO_DIR = "/home/zarch/zarchblack-repo/x86_64"
def get_gh_token():
    token = os.environ.get("GH_TOKEN", "")
    if not token:
        try:
            for git_path in ["/home/zarch/zarchblack-repo", "/home/zarch/zarchblack_iso"]:
                if os.path.exists(git_path):
                    url = subprocess.check_output(
                        ["git", "config", "--get", "remote.origin.url"],
                        cwd=git_path,
                        stderr=subprocess.DEVNULL
                    ).decode().strip()
                    if "@" in url:
                        part = url.split("://")[1].split("@")[0]
                        if ":" in part:
                            token = part.split(":")[1]
                        else:
                            token = part
                        break
        except Exception:
            pass
    return token

GH_TOKEN = get_gh_token()
OWNER = "ZarchBlack"
REPO = "zarchblack-repo"
RELEASE_ID = 333779329
KEY_ID = "96CB4D9C0E1586BBE2E0BDF9EC56F45690FD9D2D"

def make_request(url, method="GET", headers=None, data=None):
    if headers is None:
        headers = {}
    headers["Authorization"] = f"token {GH_TOKEN}"
    headers["Accept"] = "application/vnd.github.v3+json"
    
    req = urllib.request.Request(url, method=method, headers=headers, data=data)
    try:
        with urllib.request.urlopen(req) as response:
            return response.status, response.read()
    except urllib.error.HTTPError as e:
        print(f"HTTP Error: {e.code} - {e.read().decode(errors='ignore')}")
        raise e
    except Exception as e:
        print(f"Network Error: {e}")
        raise e

def get_release_assets():
    url = f"https://api.github.com/repos/{OWNER}/{REPO}/releases/{RELEASE_ID}/assets"
    _, body = make_request(url)
    assets = json.loads(body.decode())
    return {asset["name"]: (asset["id"], asset["size"]) for asset in assets}

def delete_release_asset(asset_id, name):
    print(f"Deleting old asset from release: {name} (ID: {asset_id})...")
    url = f"https://api.github.com/repos/{OWNER}/{REPO}/releases/assets/{asset_id}"
    make_request(url, method="DELETE")

def upload_release_asset(filepath):
    filename = os.path.basename(filepath)
    print(f"Uploading asset to release: {filename}...")
    
    # URL encode filename
    enc_name = urllib.parse.quote(filename)
    url = f"https://uploads.github.com/repos/{OWNER}/{REPO}/releases/{RELEASE_ID}/assets?name={enc_name}"
    
    with open(filepath, "rb") as f:
        file_data = f.read()
        
    headers = {
        "Content-Type": "application/octet-stream",
        "Content-Length": str(len(file_data))
    }
    
    make_request(url, method="POST", headers=headers, data=file_data)
    print(f"Successfully uploaded: {filename}")

def main():
    print("=== ZarchBlack GPG Repository Signing & Sync Tool ===")
    
    # 1. Verification of local path
    if not os.path.exists(REPO_DIR):
        print(f"Error: Repository directory {REPO_DIR} does not exist.")
        sys.exit(1)
        
    packages = glob.glob(os.path.join(REPO_DIR, "*.pkg.tar.zst"))
    if not packages:
        print("No packages found to sign.")
        sys.exit(0)
        
    print(f"Found {len(packages)} packages locally.")
    
    # 2. Sign all packages
    for pkg in packages:
        sig_file = pkg + ".sig"
        print(f"Signing {os.path.basename(pkg)}...")
        subprocess.run([
            "gpg", "--batch", "--yes", "--pinentry-mode", "loopback",
            "--local-user", KEY_ID, "--detach-sign", pkg
        ], check=True)
        
    # 3. Clean and recreate repository database
    print("\nRebuilding repository database index...")
    db_file = os.path.join(REPO_DIR, "zarchblack-repo.db.tar.gz")
    
    # Delete old database files
    for ext in [".db", ".db.tar.gz", ".db.tar.gz.sig", ".db.sig", ".files", ".files.tar.gz", ".files.tar.gz.sig", ".files.sig"]:
        fpath = os.path.join(REPO_DIR, "zarchblack-repo" + ext)
        if os.path.exists(fpath):
            os.remove(fpath)
            
    # Run repo-add with signature and include sigs
    cmd = ["repo-add", "--sign", "--key", KEY_ID, "--include-sigs", db_file] + packages
    subprocess.run(cmd, check=True)
    print("Repository database generated and signed successfully.")
    
    # 4. Sync with GitHub Releases
    print("\nFetching remote assets from GitHub Releases...")
    remote_assets = get_release_assets()
    
    # List all files we want to upload (packages, database files, and their signatures)
    local_files = []
    # Add packages and their signatures
    for pkg in packages:
        local_files.append(pkg)
        local_files.append(pkg + ".sig")
    
    # Add database files and their signatures
    for ext in [".db", ".db.tar.gz", ".db.tar.gz.sig", ".db.sig", ".files", ".files.tar.gz", ".files.tar.gz.sig", ".files.sig"]:
        fpath = os.path.join(REPO_DIR, "zarchblack-repo" + ext)
        if os.path.exists(fpath):
            local_files.append(fpath)
            
    print(f"Syncing {len(local_files)} files with GitHub Releases...")
    
    for filepath in local_files:
        filename = os.path.basename(filepath)
        local_size = os.path.getsize(filepath)
        
        if filename in remote_assets:
            asset_id, remote_size = remote_assets[filename]
            if local_size == remote_size:
                print(f"Skipping {filename} (Already uploaded and size matches: {local_size} bytes)")
                continue
            else:
                print(f"Size mismatch for {filename} (Local: {local_size}, Remote: {remote_size}). Replacing...")
                delete_release_asset(asset_id, filename)
                
        upload_release_asset(filepath)
        
    print("\n=== Sync and Update Completed Successfully! ===")

if __name__ == "__main__":
    main()
