{
  pkgs,
  inputs,
  ...
}: let
  scriptDir = ./scripts;
  scriptEntries = builtins.readDir scriptDir;

  regularFiles = builtins.filter (name: scriptEntries.${name} == "regular") (
    builtins.attrNames scriptEntries
  );

  substituteVars = content: builtins.replaceStrings ["{{COMMIT_PROMPT}}" "{{PULL_REQUEST_PROMPT}}"] ["${inputs.prompts}/generate/commit-message.md" "${inputs.prompts}/generate/pull-request.md"] content;

  mkScript = name: {
    name = name;
    value = pkgs.writeScriptBin (builtins.replaceStrings [".sh" ".rb"] ["" ""] name) (
      substituteVars (builtins.readFile (scriptDir + "/${name}"))
    );
  };

  bashFiles =
    builtins.filter (
      name: builtins.match ".*\\.sh$" name != null
    )
    regularFiles;
  bashSet = builtins.listToAttrs (map mkScript bashFiles);
  bashScripts = builtins.attrValues bashSet;

  rubyFiles =
    builtins.filter (
      name: builtins.match ".*\\.rb$" name != null
    )
    regularFiles;
  rubySet = builtins.listToAttrs (map mkScript rubyFiles);
  rubyScripts = builtins.attrValues rubySet;
in {
  home.packages = bashScripts ++ rubyScripts;
}
