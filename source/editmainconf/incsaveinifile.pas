{ +--------------------------------------------------------------------------+ }
{ | MM5D v0.1 * Growing house controlling and remote monitoring system       | }
{ | Copyright (C) 2019-2020 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
{ | incsaveinifile.pas                                                       | }
{ | Save configuration to ini file                                           | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// save environment characteristics file
function saveinifile(filename: string): boolean;
var
  iif: TINIFile;
  b: byte;

begin
  iif:=TIniFile.Create(filename);
  saveinifile:=true;
  try
    // section user
    iif.writestring(U,'usr_nam',usr_nam);
    iif.writestring(U,'usr_uid',usr_uid);
    for b:=1 to 3 do
      iif.writestring(U,'usr_dt'+inttostr(b),usr_dt[b]);
    // section names
    for b:=1 to 4 do
      iif.writestring(N,'nam_err'+inttostr(b),nam_err[b]);
    for b:=1 to 4 do
      iif.writestring(N,'nam_in'+inttostr(b),nam_in[b]);
    for b:=1 to 4 do
      iif.writestring(N,'nam_out'+inttostr(b),nam_out[b]);
    // section ports
    iif.writestring(P,'prt_act',inttostr(prt_act));
    for b:=1 to 4 do
      iif.writestring(P,'prt_err'+inttostr(b),inttostr(prt_err[b]));
    for b:=1 to 4 do
      iif.writestring(P,'prt_in'+inttostr(b),inttostr(prt_in[b]));
    for b:=1 to 4 do
      iif.writestring(P,'prt_out'+inttostr(b),inttostr(prt_out[b]));
    iif.writestring(P,'prt_sensor',inttostr(prt_sensor));
    iif.writestring(P,'prt_switch',inttostr(prt_switch));
    iif.writestring(P,'prt_twrgreen',inttostr(prt_twrgreen));
    iif.writestring(P,'prt_twrred',inttostr(prt_twrred));
    iif.writestring(P,'prt_twryellow',inttostr(prt_twryellow));
    // section sensors
    iif.writestring(E,'sensor_type',sensor_type);
    // section directories
    iif.writestring(D,'dir_htm',dir_htm);
    iif.writestring(D,'dir_lck',dir_lck);
    iif.writestring(D,'dir_log',dir_log);
    iif.writestring(D,'dir_msg',dir_msg);
    iif.writestring(D,'dir_shr',dir_shr);
    iif.writestring(D,'dir_tmp',dir_tmp);
    iif.writestring(D,'dir_var',dir_var);
    // openweathermap.org
    iif.ReadString(W,'api_key',api_key);
    iif.ReadString(W,'base_url',base_url);
    iif.ReadString(W,'city_name',city_name);
    // section language
    iif.writestring(L,'lng',lng);
    // section log
    iif.writestring(G,'day_log',inttostr(day_log));
    iif.writestring(G,'dbg_log',inttostr(dbg_log));
  except
    saveinifile:=false;
  end;
  iif.Free;
end;
