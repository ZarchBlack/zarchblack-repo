# Contributing to ZarchBlack

This is a **personal** distribution project. External contributions are not expected.

## Internal Workflow

1. Create feature branches from `main`
2. Test ISO builds locally before merging
3. Update package manifests when adding/removing packages
4. Tag releases with semantic versioning
5. Keep the local repository synchronized with PKGBUILD sources

## Package Guidelines

- Follow Arch Linux packaging standards
- Test packages in clean chroot before adding to local-repo
- Update repository database after adding packages
- Sign packages with GPG for production builds

## ISO Build Process

```bash
# Clean build
sudo rm -rf work/ out/
sudo mkarchiso -v -w ./work -o ./out ./kde-releng

# Quick test without rebuilding
sudo mkarchiso -v -w ./work -o ./out ./kde-releng
```
