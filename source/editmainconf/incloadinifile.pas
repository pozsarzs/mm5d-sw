{ +--------------------------------------------------------------------------+ }
{ | MM5D v0.5 * Growing house controlling and remote monitoring system       | }
{ | Copyright (C) 2019-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
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
    prt_act:=strtoint(iif.ReadString(P,'prt_act','0'));
    prt_err[1]:=strtoint(iif.ReadString(P,'prt_err1','0'));
    prt_err[2]:=strtoint(iif.ReadString(P,'prt_err2','0'));
    prt_err[3]:=strtoint(iif.ReadString(P,'prt_err3','0'));
    prt_err[4]:=strtoint(iif.ReadString(P,'prt_err4','0'));
    prt_in[1]:=strtoint(iif.ReadString(P,'prt_in1','0'));
    prt_in[2]:=strtoint(iif.ReadString(P,'prt_in2','0'));
    prt_in[3]:=strtoint(iif.ReadString(P,'prt_in3','0'));
    prt_in[4]:=strtoint(iif.ReadString(P,'prt_in4','0'));
    prt_out[1]:=strtoint(iif.ReadString(P,'prt_out1','0'));
    prt_out[2]:=strtoint(iif.ReadString(P,'prt_out2','0'));
    prt_out[3]:=strtoint(iif.ReadString(P,'prt_out3','0'));
    prt_out[4]:=strtoint(iif.ReadString(P,'prt_out4','0'));
    prt_sensor:=strtoint(iif.ReadString(P,'prt_sensor','0'));
    prt_switch:=strtoint(iif.ReadString(P,'prt_switch','0'));
    prt_twrgreen:=strtoint(iif.ReadString(P,'prt_twrgreen','0'));
    prt_twrred:=strtoint(iif.ReadString(P,'prt_twrred','0'));
    prt_twryellow:=strtoint(iif.ReadString(P,'prt_twryellow','0'));
    // section sensors
    sensor_type:=iif.ReadString(E,'sensor_type','DHT22');
    // section directories
    dir_htm:=iif.ReadString(D,'dir_htm','/var/www/html/');
    dir_tmp:=iif.ReadString(D,'dir_tmp','/var/tmp/');
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
    // section openweathermap.org
    api_key:=iif.ReadString(W,'api_key','');
    base_url:=iif.ReadString(W,'base_url','http://api.openweathermap.org/data/2.5/weather?');
    city_name:=iif.ReadString(W,'city_name','');
    // section ip cameras
    cam_show:=strtoint(iif.ReadString(I,'cam_show','0'));
    cam1_enable:=strtoint(iif.ReadString(I,'cam1_enable','0'));
    cam2_enable:=strtoint(iif.ReadString(I,'cam2_enable','0'));
    cam1_jpglink:=iif.ReadString(I,'cam1_jpglink','');
    cam2_jpglink:=iif.ReadString(I,'cam2_jpglink','');
    // section language
    lng:=iif.ReadString(L,'lng','en');
    // section log
    day_log:=strtoint(iif.ReadString(G,'day_log','0'));
    dbg_log:=strtoint(iif.ReadString(G,'dbg_log','0'));
    web_lines:=strtoint(iif.ReadString(G,'web_lines','0'));
  except
    loadinifile:=false;
  end;
  iif.Free;
end;
