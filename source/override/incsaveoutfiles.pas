{ +--------------------------------------------------------------------------+ }
{ | MM5D v0.6 * Growing house controlling and remote monitoring system       | }
{ | Copyright (C) 2019-2023 Pozsár Zsolt <pozsarzs@gmail.com>                | }
{ | incsaveoutfiles.pas                                                      | }
{ | Save out files                                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// save output files
function saveoutfiles(directory: string): boolean;
var
  b:    byte;
  outf: text;

begin
  saveoutfiles:=true;
  for b:=1 to 4 do
  try
    assignfile(outf,directory+'out'+inttostr(b));
    rewrite(outf);
    writeln(outf,outputs[b]);
    closefile(outf);
  except
    saveoutfiles:=false;
  end;
end;
