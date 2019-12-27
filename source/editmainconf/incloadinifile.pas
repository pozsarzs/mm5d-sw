{ +--------------------------------------------------------------------------+ }
{ | MM5D v0.1 * Growing house controlling and remote monitoring system       | }
{ | Copyright (C) 2019 Pozsár Zsolt <pozsar.zsolt@.szerafingomba.hu>         | }
{ | incloadinifile.pas                                                       | }
{ | Load configuration from ini file                                         | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// load environment characteristics file
function loadinifile(filename: string): boolean;
var
  iif: TINIFile;
  b: byte;
const
  D: string='directories';
  E: string='sensors';
  G: string='log';
  L: string='language';
  N: string='names';
  P: string='ports';
  U: string='user';

begin
  iif:=TIniFile.Create(filename);
  loadinifile:=true;
  try
    // section user
    usr_nam:=iif.ReadString(U,'usr_nam','');
    usr_uid:=iif.ReadString(U,'usr_uid','');
    for b:=1 to 3 do
      usr_dt[b]:=iif.ReadString(U,'usr_dt'+inttostr(b),'');
    // section names
    for b:=1 to 4 do
      nam_err[b]:=iif.ReadString(N,'nam_err'+inttostr(b),'');
    for b:=1 to 4 do
      nam_in[b]:=iif.ReadString(N,'nam_in'+inttostr(b),'');
    for b:=1 to 4 do
      nam_out[b]:=iif.ReadString(N,'nam_out'+inttostr(b),'');
    // section ports
    prt_act:=strtoint(iif.ReadString(P,'prt_act','25'));
    prt_err[1]:=strtoint(iif.ReadString(P,'prt_err1','12'));
    prt_err[2]:=strtoint(iif.ReadString(P,'prt_err2','16'));
    prt_err[3]:=strtoint(iif.ReadString(P,'prt_err3','20'));
    prt_err[4]:=strtoint(iif.ReadString(P,'prt_err4','21'));
    prt_in[1]:=strtoint(iif.ReadString(P,'prt_in','17'));
    prt_in[2]:=strtoint(iif.ReadString(P,'prt_in','18'));
    prt_in[3]:=strtoint(iif.ReadString(P,'prt_in','22'));
    prt_in[4]:=strtoint(iif.ReadString(P,'prt_in','23'));
    prt_out[1]:=strtoint(iif.ReadString(P,'prt_out','5'));
    prt_out[2]:=strtoint(iif.ReadString(P,'prt_out','6'));
    prt_out[3]:=strtoint(iif.ReadString(P,'prt_out','13'));
    prt_out[4]:=strtoint(iif.ReadString(P,'prt_out','19'));
    prt_sensor:=strtoint(iif.ReadString(P,'prt_sensor','24'));
    prt_switch:=strtoint(iif.ReadString(P,'prt_switch','26'));
    prt_twrgreen:=strtoint(iif.ReadString(P,'prt_twrgreen','3'));
    prt_twrred:=strtoint(iif.ReadString(P,'prt_twrred','2'));
    prt_twryellow:=strtoint(iif.ReadString(P,'prt_twryellow','4'));
    // section sensors
    sensor_type:=iif.ReadString(E,'sensor_type','DHT22');
    // section directories
    dir_htm:=iif.ReadString(D,'dir_htm','/var/www/html/');
    // dir_lck:=iif.ReadString(D,'dir_lck','/var/lock/');
    // dir_log:=iif.ReadString(D,'dir_log','/var/log/');
    // dir_msg:=iif.ReadString(D,'dir_msg','/usr/share/locale/');
    // dir_shr:=iif.ReadString(D,'dir_shr','/usr/share/mm5d/');
    // dir_var:=iif.ReadString(D,'dir_var','/var/lib/mm5d/');
    dir_lck:=iif.ReadString(D,'dir_lck','/var/local/lock/');
    dir_log:=iif.ReadString(D,'dir_log','/var/local/log/');
    dir_msg:=iif.ReadString(D,'dir_msg','/usr/local/share/locale/');
    dir_shr:=iif.ReadString(D,'dir_shr','/usr/local/share/mm5d/');
    dir_var:=iif.ReadString(D,'dir_var','/var/local/lib/mm5d/');
    // section language
    lng:=iif.ReadString(L,'lng','en');
    // section log
    day_log:=strtoint(iif.ReadString(G,'day_log','7'));
    dbg_log:=strtoint(iif.ReadString(G,'dbg_log','0'));
  except
    loadinifile:=false;
  end;
  iif.Free;
end;
