{ pkgs, python311Packages }:

pkgs.stdenv.mkDerivation rec {
  name = "ht_dbc";
  
  src = ./PCAN_project;
  
  buildInputs = [ python311Packages.cantools ]; # Python as a build dependency
  
  # Define the build phase to execute the scripts
  buildPhase = ''
    cantools convert hytech.sym hytech.dbc
  '';

  # Specify the output of the build process
  # In this case, it will be the generated file
  installPhase = ''
    mkdir -p $out
    mv hytech.dbc $out/hytech.dbc
  '';
}