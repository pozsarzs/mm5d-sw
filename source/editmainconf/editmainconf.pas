{ +--------------------------------------------------------------------------+ }
{ | MM5D v0.1 * Growing house controlling and remote monitoring system       | }
{ | Copyright (C) 2019 Pozsár Zsolt <pozsar.zsolt@.szerafingomba.hu>         | }
{ | editmainconf.pas                                                         | }
{ | Full-screen program for edit mm5d.ini file                               | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.
//
//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

// Exit codes:
//   0: normal exit, file is saved
//   1: command line parameter is missing
//   2: bad terminal size
//   3: cannot read file
//   4: cannot write file
//   5: normal exit, file is not saved

program editmainconf;
{$MODE OBJFPC}{$H+}
uses
  INIFiles, SysUtils, character, crt, untcommon;
var
  bottom: byte;

  // old values
  hheaterdis, mheaterdis: array[0..23] of byte;
  hhumdis, mhumdis: array[0..23] of byte;
  hventdis, mventdis: array[0..23] of byte;
  hventdislowtemp, mventdislowtemp: array[0..23] of byte;
  hhummax, mhummax: byte;
  hhummin, mhummin: byte;
  hhumoff, mhumoff: byte;
  hhumon, mhumon: byte;
  hlightsoff1, mlightsoff1, hlightsoff2, mlightsoff2: byte;
  hlightson1, mlightson1, hlightson2, mlightson2: byte;
  htempmax, mtempmax: byte;
  htempmin, mtempmin: byte;
  htempoff, mtempoff: byte;
  htempon, mtempon: byte;
  hventlowtemp, mventlowtemp: shortint;
  hventoff, mventoff: byte;
  hventon, mventon: byte;
  
  // new values
  day_log: byte;
  dbg_log: byte;
  dir_htm, dir_lck, dir_log, dir_msg, dir_shr, dir_tmp, dir_var: string;
  lng: string;
  nam_err, nam_in, nam_out: array[1..4] of string;
  prt_act, prt_sensor, prt_switch: byte;
  prt_err, prt_in, prt_out: array[1..4] of byte;
  prt_twrgreen, prt_twrred, prt_twryellow: byte;
  sensor_type: string;
  usr_dt: array[1..3] of string;
  usr_nam, usr_uid: string;
const
  VERSION: string='v0.1';
  PRGNAME: string='MM5D-EditMainConf';
  BLOCKS: array[1..8] of byte=(1,1,1,1,1,1,1,1);
  MINPOSX: array[1..8,1..6] of byte=((30,0,0,0,0,0),
                                     (26,0,0,0,0,0),
                                     (26,0,0,0,0,0),
                                     (26,0,0,0,0,0),
                                     (36,17,35,0,0,0),
                                     (46,17,35,0,0,0),
                                     (46,0,0,0,0,0),
                                     (46,17,35,53,71,46));
  MINPOSY: array[1..8,1..6] of byte=((3,0,0,0,0,0),
                                     (3,0,0,0,0,0),
                                     (3,0,0,0,0,0),
                                     (3,0,0,0,0,0),
                                     (3,10,10,0,0,0),
                                     (3,10,10,0,0,0),
                                     (3,0,0,0,0,0),
                                     (3,8,8,8,8,21));
  MAXPOSY: array[1..8,1..6] of byte=((7,0,0,0,0,0),
                                     (14,0,0,0,0,0),
                                     (20,0,0,0,0,0),
                                     (3,0,0,0,0,0),
                                     (9,21,21,0,0,0),
                                     (6,21,21,0,0,0),
                                     (6,0,0,0,0,0),
                                     (4,19,19,19,19,21));
  FOOTERS: array[1..4] of string=('<Up>/<Down> move  <Enter> edit  <Home>/<PgUp>/<PgDn>/<End> paging  <Esc> exit',
                                  '<Enter> accept  <Esc> cancel',
                                  '<Enter> accept  <Esc> cancel',
                                  '<Esc> cancel');

{$I incpage1screen.pas}
{$I incpage2screen.pas}
{$I incpage3screen.pas}
{$I incpage4screen.pas}
{$I incpage5screen.pas}
{$I incpage6screen.pas}
{$I incpage7screen.pas}
{$I incpage8screen.pas}
{$I incloadinifile.pas}
{$I incsaveinifile.pas}

procedure screen(page: byte);
begin
  background;
  case page of
    1: page1screen;
    2: page2screen;
    3: page3screen;
    4: page4screen;
    5: page5screen;
    6: page6screen;
    7: page7screen;
    8: page8screen;
  end;
  footer(bottom-1,FOOTERS[1]);
  textbackground(black);
  gotoxy(1,bottom); clreol;
end;

procedure getvalue(page,block,posy: byte);
var
  c: char;
  s: string;
begin
  textbackground(black);
  footer(bottom-1,FOOTERS[2]);
  if block=6 then footer(bottom-1,FOOTERS[3]);
  textcolor(lightgray);
  gotoxy(1,bottom); write('>');
  s:='';
  repeat
    c:=readkey;
    if (block=6) and (length(s)>0) then
      case c of
        '-': if strtoint(s)>0 then s:=inttostr(strtoint(s)*(-1));
        '+': if strtoint(s)<0 then s:=inttostr(strtoint(s)*(-1));
      end;
    if isnumber(c) then
      case block of
        1: if length(s)<2 then s:=s+c;
        6: if length(s)<3 then s:=s+c;
      else if (c='0') or (c='1') then s:=c;
      end;
    if c=#8 then delete(s,length(s),1);
    gotoxy(1,bottom); clreol; write('>'+s);
  until (c=#13) or (c=#27);
  textcolor(white);
  if (c=#13) and (length(s)>0) then
  begin
    // -- page #1 --
    if page=1 then
    begin
      // page #1 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-1,posy); write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin hhummin:=strtoint(s); write(hhummin); end;
          4: begin hhumon:=strtoint(s); write(hhumon); end;
          5: begin hhumoff:=strtoint(s); write(hhumoff); end;
          6: begin hhummax:=strtoint(s); write(hhummax); end;
        end;
      end;
      // page #1 - block #2
      if block=2 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        hhumdis[posy-10]:=strtoint(s);
        write(hhumdis[posy-10]);
      end;
      // page #1 - block #3
      if block=3 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        hhumdis[posy+2]:=strtoint(s);
        write(hhumdis[posy+2]);
      end;
    end;
    // -- page #2 --
    if page=2 then
    begin
      // page #2 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-1,posy);write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin htempmin:=strtoint(s); write(htempmin); end;
          4: begin htempon:=strtoint(s); write(htempon); end;
          5: begin htempoff:=strtoint(s); write(htempoff); end;
          6: begin htempmax:=strtoint(s); write(htempmax); end;
        end;
      end;
      // page #2 - block #2
      if block=2 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        hheaterdis[posy-10]:=strtoint(s);
        write(hheaterdis[posy-10]);
      end;
      // page #2 - block #3
      if block=3 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        hheaterdis[posy+2]:=strtoint(s);
        write(hheaterdis[posy+2]);
      end;
    end;
    // -- page #3 --
    if page=3 then
    begin
      // page #3 - block #1
      if block=1 then
      begin
        if strtoint(s)>23 then s:=inttostr(23);
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-1,posy); write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin hlightson1:=strtoint(s); write(hlightson1); end;
          4: begin hlightsoff1:=strtoint(s); write(hlightsoff1); end;
          5: begin hlightson2:=strtoint(s); write(hlightson2); end;
          6: begin hlightsoff2:=strtoint(s); write(hlightsoff2); end;
        end;
      end;
    end;
    // -- page #4 --
    if page=4 then
    begin
      // page #4 - block #1
      if block=1 then
      begin
        if strtoint(s)>59 then s:=inttostr(59);
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-1,posy); write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin hventon:=strtoint(s); write(hventon); end;
          4: begin hventoff:=strtoint(s); write(hventoff); end;
        end;
      end;
      // page #4 - block #2
      if block=2 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        hventdis[posy-8]:=strtoint(s);
        write(hventdis[posy-8]);
      end;
      // page #4 - block #3
      if block=3 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        hventdis[posy+4]:=strtoint(s);
        write(hventdis[posy+4]);
      end;
      // page #4 - block #4
      if block=4 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        hventdislowtemp[posy-8]:=strtoint(s);
        write(hventdislowtemp[posy-8]);
      end;
      // page #4 - block #5
      if block=5 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        hventdislowtemp[posy+4]:=strtoint(s);
        write(hventdislowtemp[posy+4]);
      end;
      // page #4 - block #6
      if block=6 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-2,posy); write('   ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        hventlowtemp:=strtoint(s); write(hventlowtemp);
      end;
    end;
    // -- page #5 --
    if page=5 then
    begin
      // page #5 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-1,posy); write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin mhummin:=strtoint(s); write(mhummin); end;
          4: begin mhumon:=strtoint(s); write(mhumon); end;
          5: begin mhumoff:=strtoint(s); write(mhumoff); end;
          6: begin mhummax:=strtoint(s); write(mhummax); end;
        end;
      end;
      // page #5 - block #2
      if block=2 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        mhumdis[posy-10]:=strtoint(s);
        write(mhumdis[posy-10]);
      end;
      // page #5 - block #3
      if block=3 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        mhumdis[posy+2]:=strtoint(s);
        write(mhumdis[posy+2]);
      end;
    end;
    // -- page #6 --
    if page=6 then
    begin
      // page #6 - block #1
      if block=1 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-1,posy); write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin mtempmin:=strtoint(s); write(mtempmin); end;
          4: begin mtempon:=strtoint(s); write(mtempon); end;
          5: begin mtempoff:=strtoint(s); write(mtempoff); end;
          6: begin mtempmax:=strtoint(s); write(mtempmax); end;
        end;
      end;
      // page #6 - block #2
      if block=2 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        mheaterdis[posy-10]:=strtoint(s);
        write(mheaterdis[posy-10]);
      end;
      // page #6 - block #3
      if block=3 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        mheaterdis[posy+2]:=strtoint(s);
        write(mheaterdis[posy+2]);
      end;
    end;
    // -- page #7 --
    if page=7 then
    begin
      // page #7 - block #1
      if block=1 then
      begin
        if strtoint(s)>23 then s:=inttostr(23);
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-1,posy); write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin mlightson1:=strtoint(s); write(mlightson1); end;
          4: begin mlightsoff1:=strtoint(s); write(mlightsoff1); end;
          5: begin mlightson2:=strtoint(s); write(mlightson2); end;
          6: begin mlightsoff2:=strtoint(s); write(mlightsoff2); end;
        end;
      end;
    end;
    // -- page #8 --
    if page=8 then
    begin
      // page #8 - block #1
      if block=1 then
      begin
        if strtoint(s)>59 then s:=inttostr(59);
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-1,posy); write('  ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        case posy of
          3: begin mventon:=strtoint(s); write(mventon); end;
          4: begin mventoff:=strtoint(s); write(mventoff); end;
        end;
      end;
      // page #8 - block #2
      if block=2 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        mventdis[posy-8]:=strtoint(s);
        write(mventdis[posy-8]);
      end;
      // page #8 - block #3
      if block=3 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        mventdis[posy+4]:=strtoint(s);
        write(mventdis[posy+4]);
      end;
      // page #8 - block #4
      if block=4 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        mventdislowtemp[posy-8]:=strtoint(s);
        write(mventdislowtemp[posy-8]);
      end;
      // page #8 - block #5
      if block=5 then
      begin
        gotoxy(MINPOSX[page,block],posy); textbackground(blue);
        mventdislowtemp[posy+4]:=strtoint(s);
        write(mventdislowtemp[posy+4]);
      end;
      // page #8 - block #6
      if block=6 then
      begin
        textbackground(blue);
        gotoxy(MINPOSX[page,block]-2,posy); write('   ');
        gotoxy(MINPOSX[page,block]-length(s)+1,posy);
        mventlowtemp:=strtoint(s); write(mventlowtemp);
      end;
    end;
  end;
  footer(bottom-1,FOOTERS[1]);
  gotoxy(1,bottom); clreol;
end;

function setvalues: boolean;
var
  page, block, posy: byte;
  k : char;
label back;
begin
  page:=1;
  block:=1;
  screen(page);
 back:
  textbackground(black);
  gotoxy(1,bottom); clreol;
  footer(bottom-1,FOOTERS[1]);
  posy:=MINPOSY[page,block];
  gotoxy(MINPOSX[page,block],posy);
  repeat
    k:=readkey;
    if k=#0 then k:=readkey;
    case k of
      // first page
      #71: begin
             page:=1;
             screen(page);
             block:=1;
             posy:=MINPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
           end;
      // previous page
      #73: begin
             page:=page-1;
             if page<1 then page:=1;
             screen(page);
             block:=1;
             posy:=MINPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
           end;
      // next page
      #81: begin
             page:=page+1;
             if page>8 then page:=8;
             screen(page);
             block:=1;
             posy:=MINPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
           end;
      // last page
      #79: begin
             page:=8;
             screen(page);
             block:=1;
             posy:=MINPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
           end;
       // next block on page
       #9: begin
             block:=block+1;
             if block>BLOCKS[page] then block:=1;
             posy:=MINPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
           end;
       // previous item in block
       #72: begin
             posy:=posy-1;
             if posy<MINPOSY[page,block] then posy:=MAXPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
            end;
       // next item in block
       #80: begin
             posy:=posy+1;
             if posy>MAXPOSY[page,block] then posy:=MINPOSY[page,block];
             gotoxy(MINPOSX[page,block],posy);
            end;
       // select and edit item
       #13: begin
              getvalue(page,block,posy);
              gotoxy(MINPOSX[page,block],posy);
            end;
        end;
  // exit
  until k=#27;
  footer(bottom-1,FOOTERS[4]);
  textcolor(lightgray);
  gotoxy(1,bottom); write('Save to '+paramstr(1)+'? (y/n) ');
  textcolor(white);
  repeat
    k:=lowercase(readkey);
    if k=#27 then goto back;
  until (k='y') or (k='n');
  if k='y' then setvalues:=true else setvalues:=false;
end;

function terminalsize: boolean;
begin
  if (screenwidth>=80) and (screenheight>=25)
    then terminalsize:=true
    else terminalsize:=false;
  bottom:=screenheight;
end;

begin
  textcolor(lightgray); textbackground(black);
  if paramcount=0 then
    quit(1,false,'Usage:'+#10+'    '+paramstr(0)+' /path/mm5d.ini');
  if not terminalsize
    then quit(2,false,'ERROR: Minimal terminal size is 80x25!');
  if not loadinifile(paramstr(1))
    then quit(3,false,'ERROR: Cannot read '+paramstr(1)+' file!');
  if not setvalues
    then quit(5,true,'File '+paramstr(1)+' is not saved.');
  if not saveinifile(paramstr(1))
    then quit(4,true,'ERROR: Cannot write '+paramstr(1)+' file!');
  quit(0,true,'');
end.
