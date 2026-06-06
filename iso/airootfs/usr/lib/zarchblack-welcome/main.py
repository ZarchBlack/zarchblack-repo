#!/usr/bin/env python3
"""
ZarchBlack Welcome Center
━━━━━━━━━━━━━━━━━━━━━━━━
Welcome screen for ZarchBlack Linux distribution.
Launches Calamares installer and distro tools.
© 2026 ZarchBlack Project
"""

import sys
import subprocess
import os
from pathlib import Path

from PyQt6.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout,
    QPushButton, QLabel, QFrame, QScrollArea, QCheckBox
)
from PyQt6.QtCore import Qt, QThread, pyqtSignal
from PyQt6.QtGui import QPixmap, QFont, QFontDatabase

# ── Paths ──────────────────────────────────────────────────────────────────
BASE_DIR   = Path(__file__).parent
ASSETS_DIR = BASE_DIR / "assets"
LOGO_PATH  = ASSETS_DIR / "logo.png"

AUTOSTART_FILE = Path.home() / ".config/autostart/zarchblack-welcome.desktop"

# ── Theme ──────────────────────────────────────────────────────────────────
THEME = """
QApplication, QWidget {
    background-color: #0d0d14;
    color: #e2e8f0;
    font-family: "Inter", "Segoe UI", "Ubuntu", sans-serif;
    font-size: 13px;
}
QMainWindow {
    background-color: #0d0d14;
}
QScrollArea {
    background: transparent;
    border: none;
}
QScrollBar:vertical {
    background: #12121e;
    width: 6px;
    border-radius: 3px;
    margin: 0;
}
QScrollBar::handle:vertical {
    background: #2a2a45;
    border-radius: 3px;
    min-height: 24px;
}
QScrollBar::handle:vertical:hover {
    background: #7c3aed;
}
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical { height: 0; }

#InstallBtn {
    background: qlineargradient(x1:0, y1:0, x2:1, y2:0,
        stop:0 #7c3aed, stop:1 #b060ff);
    color: #ffffff;
    border: none;
    border-radius: 12px;
    font-size: 17px;
    font-weight: 700;
    padding: 16px 48px;
    letter-spacing: 0.5px;
}
#InstallBtn:hover {
    background: qlineargradient(x1:0, y1:0, x2:1, y2:0,
        stop:0 #8b47f5, stop:1 #c070ff);
}
#InstallBtn:pressed {
    background: qlineargradient(x1:0, y1:0, x2:1, y2:0,
        stop:0 #6d28d9, stop:1 #9050ef);
}

#AppBtn {
    background-color: #12121e;
    color: #e2e8f0;
    border: 1.5px solid #2a2a45;
    border-radius: 14px;
    font-size: 14px;
    font-weight: 600;
    padding: 20px 16px;
    text-align: center;
}
#AppBtn:hover {
    background-color: #1a1a2e;
    border-color: #7c3aed;
    color: #b060ff;
}
#AppBtn:pressed {
    background-color: #16162a;
    border-color: #b060ff;
}

#SocialBtn {
    background-color: #12121e;
    color: #94a3b8;
    border: 1px solid #1a1a2e;
    border-radius: 10px;
    font-size: 13px;
    font-weight: 500;
    padding: 10px 24px;
}
#SocialBtn:hover {
    background-color: #1a1a2e;
    color: #b060ff;
    border-color: #2a2a45;
}

#Divider {
    background-color: #1a1a2e;
    max-height: 1px;
    min-height: 1px;
}

QCheckBox {
    color: #475569;
    font-size: 12px;
    spacing: 8px;
}
QCheckBox::indicator {
    width: 16px;
    height: 16px;
    border-radius: 4px;
    border: 1.5px solid #2a2a45;
    background: #12121e;
}
QCheckBox::indicator:checked {
    background-color: #7c3aed;
    border-color: #7c3aed;
}
QCheckBox::indicator:hover {
    border-color: #7c3aed;
}

#CloseBtn {
    background: transparent;
    color: #475569;
    border: 1px solid #2a2a45;
    border-radius: 8px;
    font-size: 13px;
    padding: 8px 24px;
}
#CloseBtn:hover {
    background: #12121e;
    color: #e2e8f0;
    border-color: #475569;
}
"""


class LaunchThread(QThread):
    error_signal = pyqtSignal(str)

    def __init__(self, cmd):
        super().__init__()
        self.cmd = cmd

    def run(self):
        try:
            subprocess.Popen(self.cmd, shell=True,
                             stdout=subprocess.DEVNULL,
                             stderr=subprocess.DEVNULL)
        except Exception as e:
            self.error_signal.emit(str(e))


class FeatureCard(QFrame):
    def __init__(self, icon: str, title: str, desc: str, parent=None):
        super().__init__(parent)
        self.setFixedHeight(86)
        self.setStyleSheet("""
            QFrame {
                background-color: #12121e;
                border: 1px solid #1a1a2e;
                border-radius: 12px;
            }
            QFrame:hover {
                border-color: #2a2a45;
                background-color: #16162a;
            }
        """)

        lay = QHBoxLayout(self)
        lay.setContentsMargins(16, 12, 16, 12)
        lay.setSpacing(14)

        icon_lbl = QLabel(icon)
        icon_lbl.setFont(QFont("Segoe UI Emoji", 22))
        icon_lbl.setFixedWidth(36)
        icon_lbl.setAlignment(Qt.AlignmentFlag.AlignCenter)
        lay.addWidget(icon_lbl)

        txt_lay = QVBoxLayout()
        txt_lay.setSpacing(2)

        ttl = QLabel(title)
        ttl.setStyleSheet("color:#e2e8f0; font-weight:700; font-size:14px; background:transparent; border:none;")
        txt_lay.addWidget(ttl)

        dsc = QLabel(desc)
        dsc.setStyleSheet("color:#94a3b8; font-size:12px; background:transparent; border:none;")
        dsc.setWordWrap(True)
        txt_lay.addWidget(dsc)

        lay.addLayout(txt_lay)


class WelcomeWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Welcome to ZarchBlack")
        self.setMinimumSize(860, 680)
        self.resize(920, 720)
        self._threads = []
        self._build_ui()
        self._center_on_screen()

    def _build_ui(self):
        root = QWidget()
        self.setCentralWidget(root)
        outer = QVBoxLayout(root)
        outer.setContentsMargins(0, 0, 0, 0)
        outer.setSpacing(0)

        scroll = QScrollArea()
        scroll.setWidgetResizable(True)
        scroll.setFrameShape(QFrame.Shape.NoFrame)
        outer.addWidget(scroll)

        content = QWidget()
        scroll.setWidget(content)
        main_lay = QVBoxLayout(content)
        main_lay.setContentsMargins(48, 36, 48, 32)
        main_lay.setSpacing(0)

        main_lay.addLayout(self._make_header())
        main_lay.addSpacing(28)
        main_lay.addWidget(self._divider())
        main_lay.addSpacing(24)
        main_lay.addWidget(self._make_welcome_text())
        main_lay.addSpacing(28)
        main_lay.addWidget(self._section_label("✨   Features"))
        main_lay.addSpacing(12)
        main_lay.addLayout(self._make_features())
        main_lay.addSpacing(32)
        main_lay.addWidget(self._divider())
        main_lay.addSpacing(24)
        main_lay.addWidget(self._make_install_section())
        main_lay.addSpacing(32)
        main_lay.addWidget(self._section_label("🛠   ZarchBlack Tools"))
        main_lay.addSpacing(12)
        main_lay.addLayout(self._make_apps_row())
        main_lay.addSpacing(32)
        main_lay.addWidget(self._divider())
        main_lay.addSpacing(20)
        main_lay.addWidget(self._section_label("🌐   Community & Links"))
        main_lay.addSpacing(12)
        main_lay.addLayout(self._make_social())
        main_lay.addSpacing(32)
        main_lay.addStretch()
        main_lay.addLayout(self._make_bottom_bar())

    def _make_header(self):
        lay = QHBoxLayout()
        lay.setSpacing(20)

        logo_lbl = QLabel()
        if LOGO_PATH.exists():
            pix = QPixmap(str(LOGO_PATH)).scaled(
                88, 88,
                Qt.AspectRatioMode.KeepAspectRatio,
                Qt.TransformationMode.SmoothTransformation
            )
            logo_lbl.setPixmap(pix)
        logo_lbl.setFixedSize(88, 88)
        lay.addWidget(logo_lbl, alignment=Qt.AlignmentFlag.AlignVCenter)

        txt = QVBoxLayout()
        txt.setSpacing(6)

        title = QLabel("ZarchBlack")
        title.setStyleSheet(
            "font-size:44px; font-weight:800; color:#b060ff; "
            "background:transparent; letter-spacing:1px;"
        )
        txt.addWidget(title)

        sub = QLabel("A modern Arch Linux-based distribution for professionals")
        sub.setStyleSheet("font-size:14px; color:#94a3b8; background:transparent;")
        txt.addWidget(sub)

        ver = QLabel("Version 1.0.0  •  Developed by Zero7x")
        ver.setStyleSheet("font-size:12px; color:#475569; background:transparent;")
        txt.addWidget(ver)

        lay.addLayout(txt)
        lay.addStretch()
        return lay

    def _make_welcome_text(self):
        lbl = QLabel(
            "Welcome to <span style='color:#b060ff; font-weight:700;'>ZarchBlack Linux</span>!<br><br>"
            "ZarchBlack is a modern, feature-rich distribution built on <b>Arch Linux</b>, designed "
            "specifically for software developers, cybersecurity professionals, ethical hackers, "
            "and system administrators.<br><br>"
            "It combines the flexibility and power of Arch Linux with a beautiful "
            "<b>KDE Plasma</b> desktop environment, pre-configured with a complete suite of tools "
            "ready to use right out of the box."
        )
        lbl.setWordWrap(True)
        lbl.setAlignment(Qt.AlignmentFlag.AlignLeft | Qt.AlignmentFlag.AlignTop)
        lbl.setTextFormat(Qt.TextFormat.RichText)
        lbl.setStyleSheet(
            "font-size:14px; color:#cbd5e1; line-height:1.7; "
            "background-color:#12121e; border:1px solid #1a1a2e; "
            "border-radius:12px; padding:20px 24px;"
        )
        return lbl

    def _make_features(self):
        features = [
            ("🖥", "KDE Plasma Desktop",     "Modern and customized ZarchBlack theme"),
            ("🔒", "Cybersecurity Tools",     "BlackArch tools integrated and ready"),
            ("⚡", "High Performance",        "Optimized kernel for maximum responsiveness"),
            ("📦", "Package Management",      "Pacman + AUR + Chaotic-AUR + Flatpak"),
            ("🎨", "Full Customization",      "Darkly / Kvantum / Catppuccin Mocha theme"),
            ("🔧", "Developer Ready",         "Pre-installed dev tools and environments"),
        ]

        grid = QVBoxLayout()
        grid.setSpacing(8)
        row1 = QHBoxLayout(); row1.setSpacing(8)
        row2 = QHBoxLayout(); row2.setSpacing(8)

        for i, (icon, title, desc) in enumerate(features):
            card = FeatureCard(icon, title, desc)
            (row1 if i < 3 else row2).addWidget(card)

        grid.addLayout(row1)
        grid.addLayout(row2)
        return grid

    def _make_install_section(self):
        frame = QFrame()
        frame.setStyleSheet("""
            QFrame {
                background: qlineargradient(x1:0, y1:0, x2:1, y2:1,
                    stop:0 #0f0f1a, stop:1 #14102a);
                border: 1px solid #2a2a45;
                border-radius: 16px;
            }
        """)
        lay = QVBoxLayout(frame)
        lay.setContentsMargins(32, 24, 32, 24)
        lay.setSpacing(12)

        title = QLabel("🚀   Install ZarchBlack")
        title.setStyleSheet(
            "font-size:18px; font-weight:700; color:#e2e8f0; background:transparent;"
        )
        title.setAlignment(Qt.AlignmentFlag.AlignCenter)
        lay.addWidget(title)

        desc = QLabel(
            "Click the button below to install ZarchBlack on your hard drive "
            "using the Calamares graphical installer."
        )
        desc.setWordWrap(True)
        desc.setAlignment(Qt.AlignmentFlag.AlignCenter)
        desc.setStyleSheet("font-size:13px; color:#94a3b8; background:transparent;")
        lay.addWidget(desc)

        lay.addSpacing(8)

        btn_row = QHBoxLayout()
        btn_row.setAlignment(Qt.AlignmentFlag.AlignCenter)

        install_btn = QPushButton("   Install ZarchBlack   ")
        install_btn.setObjectName("InstallBtn")
        install_btn.setFixedHeight(54)
        install_btn.setCursor(Qt.CursorShape.PointingHandCursor)
        install_btn.clicked.connect(self._launch_calamares)
        btn_row.addWidget(install_btn)
        lay.addLayout(btn_row)

        return frame

    def _make_apps_row(self):
        apps = [
            ("📦", "ZPackageManager",  "GUI package management\nfor Arch Linux",    "zpackagemanager"),
            ("🔓", "Zarch-Hacking",    "BlackArch tools manager\nfor penetration testing", "zarch-hacking"),
            ("🛡",  "ZArchGuard",      "System protection\nand security monitoring",       "zarchguard"),
        ]

        lay = QHBoxLayout()
        lay.setSpacing(12)

        for icon, name, desc, cmd in apps:
            btn = QPushButton(f"{icon}\n{name}\n{desc}")
            btn.setObjectName("AppBtn")
            btn.setFixedHeight(110)
            btn.setCursor(Qt.CursorShape.PointingHandCursor)
            btn.clicked.connect(lambda checked, c=cmd: self._launch_app(c))
            lay.addWidget(btn)

        return lay

    def _make_social(self):
        links = [
            ("  GitHub",   "https://github.com/ZarchBlack/ZARCH"),
            ("  Discord",  "https://discord.gg/YgVtrsCx"),
            ("  Telegram", "https://t.me/zarchblack"),
        ]

        lay = QHBoxLayout()
        lay.setSpacing(10)
        lay.setAlignment(Qt.AlignmentFlag.AlignCenter)

        for label, url in links:
            btn = QPushButton(label)
            btn.setObjectName("SocialBtn")
            btn.setFixedHeight(40)
            btn.setCursor(Qt.CursorShape.PointingHandCursor)
            btn.clicked.connect(lambda checked, u=url: self._open_url(u))
            lay.addWidget(btn)

        return lay

    def _make_bottom_bar(self):
        lay = QHBoxLayout()

        self.autostart_cb = QCheckBox("Show this window on startup")
        self.autostart_cb.setChecked(AUTOSTART_FILE.exists())
        self.autostart_cb.stateChanged.connect(self._toggle_autostart)
        lay.addWidget(self.autostart_cb)

        lay.addStretch()

        close_btn = QPushButton("Close")
        close_btn.setObjectName("CloseBtn")
        close_btn.setFixedSize(100, 36)
        close_btn.setCursor(Qt.CursorShape.PointingHandCursor)
        close_btn.clicked.connect(self.close)
        lay.addWidget(close_btn)

        return lay

    def _divider(self):
        d = QFrame()
        d.setObjectName("Divider")
        d.setFrameShape(QFrame.Shape.HLine)
        return d

    def _section_label(self, text: str):
        lbl = QLabel(text)
        lbl.setStyleSheet(
            "font-size:15px; font-weight:700; color:#b060ff; "
            "background:transparent; letter-spacing:0.3px;"
        )
        return lbl

    def _center_on_screen(self):
        screen = QApplication.primaryScreen().geometry()
        x = (screen.width()  - self.width())  // 2
        y = (screen.height() - self.height()) // 2
        self.move(x, y)

    def _launch_calamares(self):
        t = LaunchThread(
            "pkexec calamares 2>/dev/null || sudo calamares 2>/dev/null || calamares"
        )
        self._threads.append(t)
        t.start()

    def _launch_app(self, cmd: str):
        t = LaunchThread(cmd)
        self._threads.append(t)
        t.start()

    def _open_url(self, url: str):
        subprocess.Popen(["xdg-open", url],
                         stdout=subprocess.DEVNULL,
                         stderr=subprocess.DEVNULL)

    def _toggle_autostart(self, state: int):
        desktop = (
            "[Desktop Entry]\n"
            "Type=Application\n"
            "Name=ZarchBlack Welcome Center\n"
            "Exec=zarchblack-welcome\n"
            "Icon=zarchblack-welcome\n"
            "Hidden=false\n"
            "NoDisplay=false\n"
            "X-GNOME-Autostart-enabled=true\n"
        )
        if state == 2:
            AUTOSTART_FILE.parent.mkdir(parents=True, exist_ok=True)
            AUTOSTART_FILE.write_text(desktop)
        else:
            if AUTOSTART_FILE.exists():
                AUTOSTART_FILE.unlink()


def main():
    app = QApplication(sys.argv)
    app.setApplicationName("ZarchBlack Welcome")
    app.setOrganizationName("ZarchBlack")
    app.setStyleSheet(THEME)

    QFontDatabase.addApplicationFont("/usr/share/fonts/inter/Inter-Regular.otf")
    QFontDatabase.addApplicationFont("/usr/share/fonts/inter/Inter-Bold.otf")

    win = WelcomeWindow()
    win.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
