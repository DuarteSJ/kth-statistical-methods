{
    description = "Python development environment";
    inputs = {
        nixpkgs.url = "github:DuarteSJ/nixpkgs/current";
    };
    outputs = {
        self,
        nixpkgs,
        ...
        }: let
            pkgs = nixpkgs.legacyPackages."x86_64-linux";
            python = pkgs.python3;

            customEnvVars = ''
      export VAR="value"
      export OTHER_VAR="other value"
            '';

            customAliases = ''
      alias hw='echo \"hello world\"'
      alias test='echo \"This is a test alias\"'
            '';
        in {
            devShells.x86_64-linux.default = pkgs.mkShell {
                name = "py";
                packages = [
                    (python.withPackages (p: [
                        # Exta Python:
                        p.numpy
                        p.scipy
                        # p.pandas
                        p.matplotlib
                        p.seaborn
                        # For Jupyter workflow with Jupynium for editing notebooks in nvim (plugin required):
                        p.jupynium
                        p.nbclassic
                        p.notebook
                    ]))
                ];
                shellHook = ''
        echo -e "\n\033[1;36m🐍 Python development shell activated!\033[0m"
        echo -e "\033[0;90m    → Virtual environment: (py-env)\033[0m"

        # Apply custom environment variables and aliases
                    ${customEnvVars}
        ZSH_CMDS="${customAliases}" exec zsh
                '';
            };
        };
}
