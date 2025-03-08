{ pkgs, inputs, lib, config, ... }: let
  inherit (inputs.nvchad.lib) helpers;
  toKeymaps = key: action: { ... } @ options:
    listToUnkeyedAttrs [ key action ] // options
    |> toLuaObject
    |> (lua: { __raw = lua; });
  toKeymaps' = key: action: { mode ? "n", ... } @ options:
    { inherit key action mode; options = removeAttrs options [ "mode" ]; };
  inherit (helpers) toLuaObject mkLuaFn mkLuaFnWithName listToUnkeyedAttrs;
in {
  imports = [
    { _module.args = { inherit toKeymaps toKeymaps'; }; }
    ({ config, ...}: {
      plugins.lsp.luaConfig.pre = mkLuaFnWithName "myNixd" /* lua */ ''
        local NIXD_PATH, result = vim.env.NIXD_PATH, vim.tbl_deep_extend("force", { nixpkgs = { expr = "import <nixpkgs> {}", }, options = {}, }, ${toLuaObject (removeAttrs config.plugins.lsp.servers.nixd.settings [ "__raw" ])})

        if NIXD_PATH == nil or NIXD_PATH == "" then return result end
        -- format <name>=<flake>#<outputs>....
        NIXD_PATH:gsub("[^:]+", function (e)
          local tmp, name, source, path, res = {}, nil, nil , nil, nil
          for i in string.gmatch(e, "[^=]+") do table.insert(tmp, i) end
          name = tmp[1]
          for i in string.gmatch(tmp[2], "[^#]+") do table.insert(tmp, i) end
          source, path = tmp[3], tmp[4]
          local flake = (string.match(source, "^/nix/store/") == nil) and '"'..source..'"' or "builtins.toPath "..source
          res = { expr = "(builtins.getFlake ("..flake.."))."..path }
          if name == "pkgs" then
            result["nixpkgs"] = res
          else
            result["options"][name] = res
          end
        end)
        return result
      '';
    })
  ];
  enable = ! config.data.isMinimal or false;
  defaultEditor = true;
  nvchad.config = rec {
    base46.theme = "onedark";
    base46.theme_toggle = [ base46.theme "nightfox" ];
  };
  plugins.lazy.plugins = with pkgs.vimPlugins; [
    { pkg = smear-cursor-nvim;
      event = "BufEnter";
      config.__raw = mkLuaFn /* lua */ ''
        require("smear_cursor").setup {}
      '';
      cmd = ["SmearCursorToggle"];
      keys.__raw = toLuaObject [
        (toKeymaps "<leader>tsc" "<cmd>SmearCursorToggle<cr>" { desc = "Toggle Animation Cursor"; })
      ];
    }
    { pkg = neoscroll-nvim;
      event = "BufRead";
      config.__raw = mkLuaFn /* lua */ ''
        require("neoscroll").setup {}
      '';
    }
    { pkg = nvzone-typr;
      opts = {};
      cmd = [ "Typr" "TyprStats" ];
    }
    { pkg = telescope-nvim;
      dependencies = [ telescope-undo-nvim plenary-nvim ];
      config.__raw = mkLuaFn /* lua */ ''
        require("telescope").setup {
          extensions = { undo = {}, },
        }
        require("telescope").load_extension("undo")
        -- vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
      '';
      keys.__raw = toLuaObject [
        (toKeymaps "<leader>u" "<CMD>Telescope undo<CR>" {})
      ];
    }
    { pkg = pkgs.vimUtils.buildVimPlugin {
        pname = "showkeys";
        version = "1.0.0";
        src = pkgs.fetchFromGitHub {
          owner = "nvzone";
          repo = "showkeys";
          rev = "8daf5abb5fece0c9e1fa2c5679aaf226a80f5c38";
          hash = "sha256-0ZONzsCWJzzCYnZpr/O8t9Rmkc4A5+i7X7bkjEk5xmc=";
        };
      };
      cmd = [ "ShowkeysToggle" ];
      keys.__raw = toLuaObject [
        (toKeymaps "<leader>st" "<CMD>ShowkeysToggle<CR>" {})
      ];
      opts = {
        timeout = 2;
        maxkeys = 4;
        show_count = true;
        position = "top-right"; # bottom-left, bottom-right, bottom-center, top-left, top-right, top-center
      };
    }
    { pkg = nvim-notify;
      config.__raw = mkLuaFn /* lua */ ''
        local notify = require("notify")
        -- this for transparency
        notify.setup({ background_colour = "#000000" })
        -- this overwrites the vim notify function
        vim.notify = notify.notify
      '';
    }
    { pkg = toggleterm-nvim;
      config.__raw = mkLuaFn /* lua */ ''
        require("toggleterm").setup {}
        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new {
          cmd = "lazygit",
          hidden = true,
          direction = "float",
          float_opts = {
            border = "double",
          },
          -- function to run on opening the terminal
          on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
          end,
          -- function to run on closing the terminal
          on_close = function(term)
            vim.cmd("startinsert!")
          end,
        }

        function _lazygit_toggle()
          lazygit:toggle()
        end
      '';
      keys.__raw = toLuaObject [
        (toKeymaps "<leader>lg" "<cmd>lua _lazygit_toggle()<CR>" { desc = "Toggle Lazygit"; })
      ];
    }
    { pkg = bufferline-nvim;
      keys.__raw = toLuaObject [
        (toKeymaps "g1" ''<CMD>lua require("bufferline").go_to_buffer(1, true)<CR>'' { desc = "Go to tab 1"; })
        (toKeymaps "g2" ''<CMD>lua require("bufferline").go_to_buffer(2, true)<CR>'' { desc = "Go to tab 2"; })
        (toKeymaps "g3" ''<CMD>lua require("bufferline").go_to_buffer(3, true)<CR>'' { desc = "Go to tab 3"; })
        (toKeymaps "g4" ''<CMD>lua require("bufferline").go_to_buffer(4, true)<CR>'' { desc = "Go to tab 4"; })
        (toKeymaps "g5" ''<CMD>lua require("bufferline").go_to_buffer(5, true)<CR>'' { desc = "Go to tab 5"; })
        (toKeymaps "g6" ''<CMD>lua require("bufferline").go_to_buffer(6, true)<CR>'' { desc = "Go to tab 6"; })
        (toKeymaps "g7" ''<CMD>lua require("bufferline").go_to_buffer(7, true)<CR>'' { desc = "Go to tab 7"; })
        (toKeymaps "g8" ''<CMD>lua require("bufferline").go_to_buffer(8, true)<CR>'' { desc = "Go to tab 8"; })
        (toKeymaps "g9" ''<CMD>lua require("bufferline").go_to_buffer(9, true)<CR>'' { desc = "Go to tab 9"; })
        (toKeymaps "g0" ''<CMD>lua require("bufferline").go_to_buffer(10, true)<CR>'' { desc = "Go to tab 10"; })
      ];
    }
  ];
  globals.mapleader = " ";
  # vim.o.cursorlineopt = "both";
  keymaps = [
    (toKeymaps' "<C-k>" "<CMD>ShowkeysToggle<CR>" {})
    (toKeymaps' "C-t" { __raw = mkLuaFn /* lua */ ''require("menu").open("default")''; } {})
    (toKeymaps' "<RightMouse>" {
      __raw = mkLuaFn /* lua */ ''
        --
        vim.cmd.exec '"normal! \\<RightMouse>"'

        local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
        require("menu").open(options, { mouse = true })
      '';
    } {})
    (toKeymaps' ";" ":" { desc = "CMD enter command mode"; })
    (toKeymaps' "<C-n>" "<cmd>NvimTreeToggle <CR><ESC>" { mode = "i"; desc = "Toggle NvimTree"; })
    (toKeymaps' "<A-t>" {
      __raw = mkLuaFn /* lua */ ''require("nvchad.themes").open { style = "compat", border = true, }'';
    } { desc = "Show themes menu"; })
  ];
  # add filetype
  filetype.filename = {
    "build.zig.zon" = "zig";
  };
  filetype.pattern = {
    ".*%.blade%.php" = "blade";
    ".*/ghostty/config" = "toml";
    ".*/ghostty/themes/.*%.conf" = "dosini";
    ".*/zed/.*%.json" = "jsonc";
  };
  plugins.treesitter.nixvimInjections = true;
  plugins.treesitter.settings.auto_install = false;
  plugins.lsp.servers = {
    # rust_analyzer.enable = true;
    # rust_analyzer.installCargo = true;
    # rust_analyzer.installRustc = true;
    nixd.enable = true;
    nixd.settings = {
      __raw = "myNixd()";
      diagnostic.surpress = [ "sema-escaping-with" ];
    };
    zls.enable = true;
    volar.enable = true;
    clangd.enable = true;
    # vls.enable = true;
    # intelephense.enable = true;
    # phpactor.enable = true;
    jsonls.enable = true;
    # omnisharp.enable = true;
    # omnisharp.cmd = [ "${lib.getExe pkgs.omnisharp-roslyn}" ];
    # omnisharp.rootDir = /* lua */ ''require("lspconfig").util.root_pattern('*.sln', '*.csproj', 'omnisharp.json', 'function.json')'';
    # omnisharp.settings.enableRoslynAnalyzers = true;
    yamlls.enable = true;
    # mint.enable = true;
    # csharp_ls.enable = true;
    ts_ls.enable = true;
    ts_ls.rootDir = /* lua */ ''require("lspconfig").util.root_pattern("package.json", "tsconfig.json")'';
    ts_ls.extraOptions.single_file_support = false;
    denols.enable = true;
    denols.rootDir = /* lua */ ''require("lspconfig").util.root_pattern("deno.json", "deno.jsonc")'';
  };
  # plugins.treesitter.folding = true;
  plugins.treesitter.settings.indent.enable = false;
  plugins.treesitter.settings.highlight.enable = true;
  # plugins.treesitter.nixvimInjections = true;
  # plugins.treesitter.nixGrammars = true;
  plugins.treesitter.grammarPackages =
    (builtins.map (x: pkgs.vimPlugins.nvim-treesitter.builtGrammars.${x})
      [
        "asm"
        "bash"
        "c"
        "cmake"
        "comment"
        "css"
        "dhall"
        "diff"
        "dockerfile"
        "dot"
        "fish"
        "git_config"
        "git_rebase"
        "gitattributes"
        "gitcommit"
        "gitignore"
        "go"
        "gomod"
        "gosum"
        "gotmpl"
        "gpg"
        "graphql"
        "haskell"
        "haskell_persistent"
        "hcl"
        "helm"
        "html"
        "http"
        "javascript"
        "jq"
        "jsdoc"
        "json"
        "latex"
        "lua"
        "luadoc"
        "luap"
        "luau"
        "make"
        "markdown"
        "markdown_inline"
        "mermaid"
        "nix"
        "norg"
        "ocaml"
        "ocaml_interface"
        "ocamllex"
        "passwd"
        "po"
        "proto"
        "pymanifest"
        "python"
        "query"
        "regex"
        "rust"
        "rescript"
        "sql"
        "ssh_config"
        "templ"
        "terraform"
        "textproto"
        "tmux"
        "todotxt"
        "toml"
        "tsx"
        "typescript"
        "vhs"
        "vim"
        "vimdoc"
        "xml"
        "yaml"
      ]) ++ [
  ];
}
