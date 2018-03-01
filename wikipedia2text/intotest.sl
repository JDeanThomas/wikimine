$handle = openf(@ARGV[0]);

@handles = @();
for ($x = 0; $x < 1; $x++)
{
   push(@handles, openf(">files $+ $x $+ .sh"));
}

println("#!/bin/sh");

$x = 0;
while $txt (readln($handle))
{
   $out = strrep($txt, '.txt', '.xml');
   println(@handles[$x % 1], "php ./wikipedia2text/wiki2xml/php/wiki2xml_command.php ./ $+ $txt ./ $+ $out");
   $x++;
}

foreach $handlez (@handles)
{
   closef($handlez);
}

closef($handle);
