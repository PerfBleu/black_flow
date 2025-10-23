cmake_minimum_required(VERSION 3.16)

project(blackflow VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 QuickEffects)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appblackflow
    main.cpp
    src/utils.h
    src/utils.cxx
    src/ytdlp.h
    src/ytdlp.cxx
)

qt_add_qml_module(appblackflow
    URI blackflow
    VERSION 1.0
    QML_FILES
        ui/Main.qml
        ui/SideNav.qml
        RESOURCES resources.qrc ui/assets/bolt.svg ui/assets/bolt.png ui/assets/download.svg
                  ui/assets/paste.svg ui/assets/merge.svg
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appblackflow PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appblackflow
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appblackflow
    PRIVATE Qt6::Quick
            Qt6::QuickControls2
            Qt6::QuickEffects
)

include(GNUInstallDirs)
install(TARGETS appblackflow
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
