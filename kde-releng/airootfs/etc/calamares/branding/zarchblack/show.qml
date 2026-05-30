/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2015 Teo Mrnjavac <teo@kde.org>
 *   SPDX-FileCopyrightText: 2018 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 *   Calamares is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Calamares. If not, see <http://www.gnu.org/licenses/>.
 * 
 *   ZarchBlack custom settings
 */

import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation
{
    id: presentation

    function nextSlide() {
        console.log("Process is running in the background...");
        presentation.goToNextSlide();
    }

    Timer {
        id: advanceTimer
        interval: 60000
        running: true
        repeat: true
        onTriggered: nextSlide()
    }

    Slide {
           anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            border.width: 0
            color: "#051531"
            Image {
                id: slide01
                source: "slide01.png"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
            }
        }
    }

    Slide {
           anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            border.width: 0
            color: "#051531"
            Image {
                id: slide02
                source: "slide02.png"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
            }
        }
    }

    Slide {
            anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            border.width: 0
            color: "#051531"
            Image {
                id: slide03
                source: "slide03.png"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
            }
        }
    }

    Slide {
           anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            border.width: 0
            color: "#051531"
            Image {
                id: slide04
                source: "slide04.png"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
            }
        }
    }

    Slide {
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            border.width: 0
            color: "#051531"
            Image {
                id: slide05
                source: "slide05.png"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
            }
        }
    }

    Slide {
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            border.width: 0
            color: "#051531"
            Image {
                id: slide06
                source: "slide06.png"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
            }
        }
    }

    Slide {
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            border.width: 0
            color: "#051531"
            Image {
                id: slide07
                source: "slide07.png"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
            }
        }
    }

    Slide {
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            border.width: 0
            color: "#051531"
            Image {
                id: slide08
                source: "slide08.png"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
            }
        }
    }

    Slide {
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            border.width: 0
            color: "#051531"
            Image {
                id: slide09
                source: "slide09.png"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
            }
        }
    }

    Slide {
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            border.width: 0
            color: "#051531"
            Image {
                id: slide10
                source: "slide10.png"
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent
            }
        }
    }

    function onActivate() {
        console.log("QML Component (default slideshow) activated");
        presentation.currentSlide = 0;
    }

    function onLeave() {
        console.log("QML Component (default slideshow) deactivated");
    }
}

