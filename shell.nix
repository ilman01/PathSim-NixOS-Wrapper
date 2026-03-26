{ pkgs ? import <nixpkgs> {} }:

let
  runtimeLibs = with pkgs; [
    glib
    gtk3
    xorg.libXtst
    xorg.libXxf86vm
    libGL
  ];
in
pkgs.mkShell {
  packages = with pkgs; [
    jdk11            # or jdk8 if needed
    maven
    openjfx
  ] ++ runtimeLibs;

  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath runtimeLibs}
    export JAVA_HOME=${pkgs.jdk17}
    
    # Needed sometimes for GTK apps (fixes weird runtime issues)
    export GSETTINGS_SCHEMA_DIR=${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas

    run-app() {
      chmod +x ./run.sh
      ./run.sh
    }

    echo "Type 'run-app' to start PathSim"
  '';
}