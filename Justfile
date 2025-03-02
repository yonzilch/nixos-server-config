# set hostname environment
hostname := `hostname`



gc:
  # let system gc (remove unused packages, etc)
  sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system
  sudo nix-collect-garbage --delete-old


update:
  # let flake update
  nix flake update --extra-experimental-features flakes --extra-experimental-features nix-command


upgrade:
  # let system totally upgrade
  sudo nixos-rebuild switch --flake .#{{hostname}} --show-trace


install input:
  ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -d -i ; git add . ; clan machines install {{input}} --target-host {{input}} --update-hardware-config nixos-facter ; ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -e -i


deploy input:
  ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -d -i ; git add . ; clan machines update {{input}} --debug ; ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -e -i


deploy-all:
  ls sops/eval/**/*.nix | xargs -n 1 sops -d -i ; git add . ; clan machines update --debug ; ls sops/eval/**/*.nix | xargs -n 1 sops -e -i


encrypt input:
  ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -e -i


decrypt input:
  ls sops/eval/{{input}}/*.nix | xargs -n 1 sops -d -i
