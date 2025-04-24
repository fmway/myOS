# gdm with background
# place your background to /etc/current-background
{ super, self, ... }:
{
  __output.patches.__append = [
    ./bg.patch
  ];
}
