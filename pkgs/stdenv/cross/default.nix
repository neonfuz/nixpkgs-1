{ lib
, localSystem, crossSystem, config, overlays
}:

let
  bootStages = import ../. {
    inherit lib localSystem overlays;
    crossSystem = null;
    # Ignore custom stdenvs when cross compiling for compatability
    config = builtins.removeAttrs config [ "replaceStdenv" ];
  };

in lib.init bootStages ++ [

  # Regular native packages
  (somePrevStage: lib.last bootStages somePrevStage // {
    # It's OK to change the built-time dependencies
    allowCustomOverrides = true;
  })

  # Build tool Packages
  (vanillaPackages: {
    inherit config overlays;
    selfBuild = false;
    stdenv =
      assert vanillaPackages.hostPlatform == localSystem;
      assert vanillaPackages.targetPlatform == localSystem;
      vanillaPackages.stdenv.override { targetPlatform = crossSystem; };
    # It's OK to change the built-time dependencies
    allowCustomOverrides = true;
  })

  # Run Packages
  (buildPackages: {
    inherit config overlays;
    selfBuild = false;
    stdenv = buildPackages.makeStdenvCross {
      inherit (buildPackages) stdenv;
      buildPlatform = localSystem;
      hostPlatform = crossSystem;
      targetPlatform = crossSystem;
      cc = if crossSystem.useiOSPrebuilt or false
             then buildPackages.darwin.iosSdkPkgs.clang
           else if crossSystem.useAndroidPrebuilt
             then buildPackages.androidenv."androidndkPkgs_${crossSystem.ndkVer}".gcc
           else buildPackages.gcc;
    };
  })

]
