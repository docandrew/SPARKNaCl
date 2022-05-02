with SPARKNaCl;       use SPARKNaCl;
with SPARKNaCl.MAC;   use SPARKNaCl.MAC;
with SPARKNaCl.Debug; use SPARKNaCl.Debug;
procedure HMAC
is
   function To_Byte_Seq (s : String) return Byte_Seq is
      ret : Byte_Seq (N32 (s'First - 1) .. N32 (s'Last - 1));
   begin
      for i in s'Range loop
         ret (N32 (i - 1)) := Character'Pos (s (i));
      end loop;
      return ret;
   end To_Byte_Seq;

   --  Test vectors from RFC 4231
   --  https://www.rfc-editor.org/rfc/rfc4231.html

   Key1  : constant Byte_Seq (0 .. 19) := (others => 16#0b#);
   Data1 : constant Byte_Seq := To_Byte_Seq ("Hi There");

   --  key shorter than length of HMAC output

   Key2  : constant Byte_Seq := To_Byte_Seq ("Jefe");
   Data2 : constant Byte_Seq := To_Byte_Seq (
      "what do ya want for nothing?");

   --  combined length of key and data larger than 64 bytes

   Key3  : constant Byte_Seq (0 .. 19) := (others => 16#aa#);
   Data3 : constant Byte_Seq (0 .. 49) := (others => 16#dd#);

   --  combined length of key and data larger than 64 bytes

   Key4  : constant Byte_Seq (0 .. 24) := (
      16#01#, 16#02#, 16#03#, 16#04#, 16#05#, 16#06#, 16#07#, 16#08#, 
      16#09#, 16#0a#, 16#0b#, 16#0c#, 16#0d#, 16#0e#, 16#0f#, 16#10#,
      16#11#, 16#12#, 16#13#, 16#14#, 16#15#, 16#16#, 16#17#, 16#18#, 
      16#19#
   );

   Data4 : constant Byte_Seq (0 .. 49) := (others => 16#cd#);

   --  test with truncation of output to 128 bits

   Key5  : constant Byte_Seq (0 .. 19) := (others => 16#0c#);

   Data5 : constant Byte_Seq := To_Byte_Seq (
      "Test With Truncation");

   --  test with key larger than 128 bytes

   Key6  : constant Byte_Seq (0 .. 130) := (others => 16#aa#);
   Data6 : constant Byte_Seq := To_Byte_Seq (
      "Test Using Larger Than Block-Size Key - Hash Key First");

   --  test with key and data larger than 128 bytes

   Key7  : constant Byte_Seq (0 .. 130) := (others => 16#aa#);
   Data7 : constant Byte_Seq := To_Byte_Seq (
      "This is a test using a larger than block-size key and a larger " &
      "than block-size data. The key needs to be hashed before being " &
      "used by the HMAC algorithm.");

   --  NIST Test Vectors from:
   --  https://csrc.nist.gov/projects/ \
   --   cryptographic-algorithm-validation-program/message-authentication
   --  Section [L = 32]

   NIST_K0  : constant Byte_Seq := (
      16#6f#, 16#35#, 16#62#, 16#8d#, 16#65#, 16#81#, 16#34#, 16#35#,
      16#53#, 16#4b#, 16#5d#, 16#67#, 16#fb#, 16#db#, 16#54#, 16#cb#,
      16#33#, 16#40#, 16#3d#, 16#04#, 16#e8#, 16#43#, 16#10#, 16#3e#,
      16#63#, 16#99#, 16#f8#, 16#06#, 16#cb#, 16#5d#, 16#f9#, 16#5f#,
      16#eb#, 16#bd#, 16#d6#, 16#12#, 16#36#, 16#f3#, 16#32#, 16#45#
   );

   NIST_D0 : constant Byte_Seq := (
      16#75#, 16#2c#, 16#ff#, 16#52#, 16#e4#, 16#b9#, 16#07#, 16#68#,
      16#55#, 16#8e#, 16#53#, 16#69#, 16#e7#, 16#5d#, 16#97#, 16#c6#,
      16#96#, 16#43#, 16#50#, 16#9a#, 16#5e#, 16#59#, 16#04#, 16#e0#,
      16#a3#, 16#86#, 16#cb#, 16#e4#, 16#d0#, 16#97#, 16#0e#, 16#f7#,
      16#3f#, 16#91#, 16#8f#, 16#67#, 16#59#, 16#45#, 16#a9#, 16#ae#,
      16#fe#, 16#26#, 16#da#, 16#ea#, 16#27#, 16#58#, 16#7e#, 16#8d#,
      16#c9#, 16#09#, 16#dd#, 16#56#, 16#fd#, 16#04#, 16#68#, 16#80#,
      16#5f#, 16#83#, 16#40#, 16#39#, 16#b3#, 16#45#, 16#f8#, 16#55#,
      16#cf#, 16#e1#, 16#9c#, 16#44#, 16#b5#, 16#5a#, 16#f2#, 16#41#,
      16#ff#, 16#f3#, 16#ff#, 16#cd#, 16#80#, 16#45#, 16#cd#, 16#5c#,
      16#28#, 16#8e#, 16#6c#, 16#4e#, 16#28#, 16#4c#, 16#37#, 16#20#,
      16#57#, 16#0b#, 16#58#, 16#e4#, 16#d4#, 16#7b#, 16#8f#, 16#ee#,
      16#ed#, 16#c5#, 16#2f#, 16#d1#, 16#40#, 16#1f#, 16#69#, 16#8a#,
      16#20#, 16#9f#, 16#cc#, 16#fa#, 16#3b#, 16#4c#, 16#0d#, 16#9a#,
      16#79#, 16#7b#, 16#04#, 16#6a#, 16#27#, 16#59#, 16#f8#, 16#2a#,
      16#54#, 16#c4#, 16#1c#, 16#cd#, 16#7b#, 16#5f#, 16#59#, 16#2b#
   );

   NIST_K1 : constant Byte_Seq := (
      16#17#, 16#B5#, 16#28#, 16#58#, 16#E3#, 16#E1#, 16#35#, 16#BE#,
      16#44#, 16#40#, 16#D7#, 16#DF#, 16#0C#, 16#A9#, 16#96#, 16#F4#,
      16#1C#, 16#CB#, 16#78#, 16#B7#, 16#D8#, 16#CC#, 16#19#, 16#24#,
      16#D8#, 16#30#, 16#FE#, 16#81#, 16#E0#, 16#FD#, 16#27#, 16#9C#,
      16#13#, 16#1C#, 16#E3#, 16#54#, 16#63#, 16#03#, 16#E9#, 16#5A#
   );

   NIST_D1 : constant Byte_Seq := (
      16#E0#, 16#EF#, 16#F0#, 16#0F#, 16#3C#, 16#46#, 16#E9#, 16#6C#,
      16#8D#, 16#5B#, 16#D1#, 16#81#, 16#28#, 16#3E#, 16#46#, 16#05#,
      16#34#, 16#8E#, 16#3F#, 16#A1#, 16#0B#, 16#47#, 16#94#, 16#5D#,
      16#E3#, 16#DC#, 16#C1#, 16#59#, 16#AE#, 16#86#, 16#E7#, 16#BD#,
      16#3F#, 16#DB#, 16#13#, 16#F2#, 16#AD#, 16#A2#, 16#C3#, 16#13#,
      16#FC#, 16#E6#, 16#A6#, 16#9E#, 16#FA#, 16#49#, 16#A4#, 16#70#,
      16#68#, 16#9B#, 16#1E#, 16#F0#, 16#5A#, 16#AB#, 16#77#, 16#8A#,
      16#E1#, 16#5D#, 16#D3#, 16#5F#, 16#E6#, 16#FD#, 16#1E#, 16#3A#,
      16#59#, 16#D3#, 16#51#, 16#C6#, 16#8C#, 16#F8#, 16#F0#, 16#FF#,
      16#D9#, 16#68#, 16#D7#, 16#E7#, 16#8B#, 16#57#, 16#37#, 16#7A#,
      16#FC#, 16#C9#, 16#DC#, 16#E3#, 16#FA#, 16#5D#, 16#B1#, 16#F0#,
      16#6F#, 16#69#, 16#85#, 16#C4#, 16#41#, 16#4C#, 16#0F#, 16#CC#,
      16#78#, 16#00#, 16#30#, 16#F4#, 16#9F#, 16#EF#, 16#79#, 16#1A#,
      16#6C#, 16#08#, 16#ED#, 16#C2#, 16#A3#, 16#11#, 16#08#, 16#0C#,
      16#37#, 16#3F#, 16#00#, 16#E4#, 16#B2#, 16#04#, 16#4A#, 16#79#,
      16#D8#, 16#28#, 16#60#, 16#F0#, 16#87#, 16#1B#, 16#C2#, 16#59#
   );

   NIST_K2 : constant Byte_Seq := (
      16#7C#, 16#67#, 16#41#, 16#0E#, 16#0A#, 16#9E#, 16#3D#, 16#7A#,
      16#E4#, 16#F3#, 16#D0#, 16#4E#, 16#FF#, 16#1C#, 16#27#, 16#16#,
      16#89#, 16#1E#, 16#82#, 16#1C#, 16#6E#, 16#C1#, 16#DC#, 16#82#,
      16#21#, 16#42#, 16#CE#, 16#8D#, 16#99#, 16#49#, 16#B1#, 16#44#,
      16#9A#, 16#1A#, 16#03#, 16#3A#, 16#35#, 16#0F#, 16#0B#, 16#A8#
   );

   NIST_D2 : constant Byte_Seq := (
      16#BF#, 16#D1#, 16#66#, 16#79#, 16#3A#, 16#BD#, 16#CF#, 16#FB#,
      16#BD#, 16#56#, 16#DF#, 16#76#, 16#91#, 16#50#, 16#D1#, 16#46#,
      16#6C#, 16#18#, 16#A6#, 16#7A#, 16#F4#, 16#52#, 16#C7#, 16#E6#,
      16#7F#, 16#86#, 16#ED#, 16#74#, 16#1D#, 16#16#, 16#3E#, 16#BB#,
      16#D8#, 16#74#, 16#B9#, 16#D3#, 16#3A#, 16#91#, 16#D3#, 16#67#,
      16#10#, 16#99#, 16#62#, 16#0B#, 16#6E#, 16#DD#, 16#BB#, 16#D0#,
      16#F3#, 16#11#, 16#17#, 16#16#, 16#4E#, 16#B7#, 16#3C#, 16#A2#,
      16#01#, 16#DB#, 16#59#, 16#F1#, 16#65#, 16#01#, 16#31#, 16#CB#,
      16#EF#, 16#5C#, 16#7B#, 16#1B#, 16#B1#, 16#40#, 16#89#, 16#FD#,
      16#24#, 16#DA#, 16#29#, 16#19#, 16#24#, 16#1F#, 16#C9#, 16#30#,
      16#3C#, 16#02#, 16#DE#, 16#F4#, 16#24#, 16#EA#, 16#86#, 16#1D#,
      16#88#, 16#63#, 16#6B#, 16#B9#, 16#0B#, 16#13#, 16#EB#, 16#C3#,
      16#8C#, 16#F1#, 16#77#, 16#F8#, 16#A8#, 16#B1#, 16#39#, 16#E6#,
      16#80#, 16#82#, 16#FA#, 16#46#, 16#BC#, 16#FC#, 16#42#, 16#8B#,
      16#D0#, 16#54#, 16#C1#, 16#BB#, 16#7D#, 16#D3#, 16#ED#, 16#7E#,
      16#9B#, 16#86#, 16#ED#, 16#75#, 16#17#, 16#36#, 16#B6#, 16#CC#
   );

   NIST_K3 : constant Byte_Seq := (
      16#B2#, 16#C4#, 16#50#, 16#12#, 16#8D#, 16#07#, 16#44#, 16#42#,
      16#1C#, 16#3F#, 16#31#, 16#FA#, 16#B3#, 16#7B#, 16#BC#, 16#DF#,
      16#B5#, 16#A2#, 16#FF#, 16#2F#, 16#B7#, 16#06#, 16#D1#, 16#F7#,
      16#E2#, 16#3C#, 16#48#, 16#86#, 16#99#, 16#2C#, 16#7D#, 16#21#,
      16#5C#, 16#64#, 16#8F#, 16#F8#, 16#ED#, 16#B2#, 16#EB#, 16#59#
   );

   NIST_D3 : constant Byte_Seq := (
      16#F6#, 16#98#, 16#9E#, 16#BB#, 16#07#, 16#AA#, 16#DA#, 16#EE#,
      16#F9#, 16#70#, 16#F0#, 16#B5#, 16#CE#, 16#B8#, 16#06#, 16#EC#,
      16#FF#, 16#E7#, 16#7C#, 16#C2#, 16#0F#, 16#3C#, 16#22#, 16#1A#,
      16#66#, 16#59#, 16#A9#, 16#31#, 16#5D#, 16#FF#, 16#58#, 16#81#,
      16#96#, 16#19#, 16#00#, 16#E6#, 16#8E#, 16#FC#, 16#32#, 16#00#,
      16#75#, 16#ED#, 16#AF#, 16#D8#, 16#3D#, 16#E3#, 16#20#, 16#C6#,
      16#F1#, 16#8F#, 16#08#, 16#92#, 16#48#, 16#9A#, 16#F6#, 16#D9#,
      16#7A#, 16#2E#, 16#FF#, 16#B2#, 16#52#, 16#B7#, 16#6B#, 16#92#,
      16#84#, 16#EB#, 16#AF#, 16#6D#, 16#42#, 16#08#, 16#9C#, 16#1E#,
      16#0A#, 16#5C#, 16#D5#, 16#09#, 16#C2#, 16#0B#, 16#86#, 16#FF#,
      16#06#, 16#0D#, 16#53#, 16#62#, 16#C1#, 16#76#, 16#8F#, 16#89#,
      16#FA#, 16#FA#, 16#AF#, 16#65#, 16#F1#, 16#B0#, 16#FE#, 16#65#,
      16#6B#, 16#16#, 16#92#, 16#98#, 16#4A#, 16#56#, 16#7E#, 16#12#,
      16#60#, 16#C7#, 16#49#, 16#90#, 16#85#, 16#B7#, 16#9F#, 16#5F#,
      16#E7#, 16#68#, 16#47#, 16#79#, 16#A2#, 16#58#, 16#55#, 16#F2#,
      16#91#, 16#C5#, 16#A1#, 16#92#, 16#63#, 16#71#, 16#77#, 16#C4#
   );

   NIST_K4 : constant Byte_Seq := (
      16#A7#, 16#74#, 16#43#, 16#21#, 16#D7#, 16#39#, 16#38#, 16#B8#,
      16#EE#, 16#A1#, 16#37#, 16#54#, 16#90#, 16#90#, 16#29#, 16#88#,
      16#1B#, 16#BD#, 16#72#, 16#74#, 16#39#, 16#FE#, 16#27#, 16#31#,
      16#B1#, 16#C6#, 16#7B#, 16#70#, 16#83#, 16#EB#, 16#7B#, 16#5D#,
      16#33#, 16#AD#, 16#FC#, 16#CA#, 16#65#, 16#F5#, 16#D1#, 16#89#
   );

   NIST_D4 : constant Byte_Seq := (
      16#71#, 16#29#, 16#9C#, 16#A3#, 16#DA#, 16#FF#, 16#23#, 16#31#,
      16#08#, 16#2D#, 16#B3#, 16#70#, 16#BD#, 16#F8#, 16#CE#, 16#EC#,
      16#22#, 16#7B#, 16#71#, 16#BD#, 16#C4#, 16#9C#, 16#3B#, 16#14#,
      16#DC#, 16#3F#, 16#D2#, 16#13#, 16#D3#, 16#BA#, 16#83#, 16#E2#,
      16#05#, 16#88#, 16#28#, 16#FF#, 16#C6#, 16#41#, 16#4F#, 16#D5#,
      16#A2#, 16#C9#, 16#98#, 16#91#, 16#E9#, 16#C8#, 16#5F#, 16#31#,
      16#6C#, 16#5B#, 16#9B#, 16#DD#, 16#81#, 16#0A#, 16#06#, 16#7B#,
      16#4D#, 16#F9#, 16#7F#, 16#7E#, 16#42#, 16#62#, 16#AC#, 16#FE#,
      16#E6#, 16#42#, 16#E3#, 16#0E#, 16#D6#, 16#53#, 16#4B#, 16#4A#,
      16#0B#, 16#3B#, 16#3E#, 16#AF#, 16#5D#, 16#03#, 16#F2#, 16#B0#,
      16#45#, 16#CA#, 16#59#, 16#85#, 16#E7#, 16#BB#, 16#45#, 16#C7#,
      16#50#, 16#3C#, 16#D0#, 16#3A#, 16#FC#, 16#68#, 16#FB#, 16#EA#,
      16#9B#, 16#C0#, 16#95#, 16#79#, 16#14#, 16#1D#, 16#5F#, 16#B7#,
      16#CB#, 16#EA#, 16#6D#, 16#73#, 16#20#, 16#8F#, 16#CF#, 16#91#,
      16#38#, 16#30#, 16#71#, 16#5D#, 16#FF#, 16#98#, 16#40#, 16#1F#,
      16#6D#, 16#70#, 16#8E#, 16#F0#, 16#09#, 16#B5#, 16#B8#, 16#CB#
   );

   NIST_K15 : constant Byte_Seq := (
      16#14#, 16#D4#, 16#5C#, 16#A2#, 16#A3#, 16#D4#, 16#97#, 16#7D#,
      16#AB#, 16#2B#, 16#7D#, 16#44#, 16#2C#, 16#6F#, 16#9E#, 16#57#,
      16#CE#, 16#34#, 16#8E#, 16#0A#, 16#6A#, 16#80#, 16#8B#, 16#B3#,
      16#CC#, 16#7F#, 16#60#, 16#02#, 16#B8#, 16#77#, 16#89#, 16#91#,
      16#2A#, 16#FD#, 16#98#, 16#BC#, 16#E2#, 16#6A#, 16#D8#, 16#B3#
   );

   NIST_D15 : constant Byte_Seq := (
      16#0C#, 16#29#, 16#4A#, 16#31#, 16#8B#, 16#7C#, 16#1E#, 16#88#,
      16#46#, 16#49#, 16#FE#, 16#54#, 16#E4#, 16#A8#, 16#72#, 16#85#,
      16#E4#, 16#2F#, 16#86#, 16#8E#, 16#3D#, 16#0A#, 16#85#, 16#19#,
      16#41#, 16#4E#, 16#05#, 16#F9#, 16#C7#, 16#8B#, 16#23#, 16#60#,
      16#89#, 16#A1#, 16#10#, 16#52#, 16#CB#, 16#D4#, 16#CD#, 16#59#,
      16#3E#, 16#22#, 16#32#, 16#7B#, 16#23#, 16#D3#, 16#35#, 16#69#,
      16#B3#, 16#53#, 16#69#, 16#F9#, 16#BF#, 16#3D#, 16#C5#, 16#D6#,
      16#94#, 16#B8#, 16#A7#, 16#76#, 16#21#, 16#06#, 16#18#, 16#4D#,
      16#5C#, 16#5A#, 16#52#, 16#41#, 16#E1#, 16#EA#, 16#80#, 16#5D#,
      16#DC#, 16#46#, 16#C4#, 16#C9#, 16#2A#, 16#E8#, 16#7E#, 16#FA#,
      16#BB#, 16#0C#, 16#CC#, 16#26#, 16#3B#, 16#C2#, 16#4D#, 16#FB#,
      16#F1#, 16#41#, 16#2B#, 16#90#, 16#E7#, 16#7E#, 16#58#, 16#9C#,
      16#4B#, 16#FD#, 16#17#, 16#E6#, 16#15#, 16#E7#, 16#BF#, 16#FC#,
      16#EA#, 16#5E#, 16#BB#, 16#28#, 16#40#, 16#0D#, 16#D6#, 16#A0#,
      16#C4#, 16#03#, 16#B6#, 16#FD#, 16#F8#, 16#C1#, 16#A5#, 16#EE#,
      16#21#, 16#91#, 16#98#, 16#2E#, 16#60#, 16#1A#, 16#69#, 16#B3#
   );

   NIST_K30 : constant Byte_Seq := (
      16#97#, 16#79#, 16#D9#, 16#12#, 16#06#, 16#42#, 16#79#, 16#7F#,
      16#17#, 16#47#, 16#02#, 16#5D#, 16#5B#, 16#22#, 16#B7#, 16#AC#,
      16#60#, 16#7C#, 16#AB#, 16#08#, 16#E1#, 16#75#, 16#8F#, 16#2F#,
      16#3A#, 16#46#, 16#C8#, 16#BE#, 16#1E#, 16#25#, 16#C5#, 16#3B#,
      16#8C#, 16#6A#, 16#8F#, 16#58#, 16#FF#, 16#EF#, 16#A1#, 16#76#
   );

   NIST_D30 : constant Byte_Seq := (
      16#B1#, 16#68#, 16#9C#, 16#25#, 16#91#, 16#EA#, 16#F3#, 16#C9#,
      16#E6#, 16#60#, 16#70#, 16#F8#, 16#A7#, 16#79#, 16#54#, 16#FF#,
      16#B8#, 16#17#, 16#49#, 16#F1#, 16#B0#, 16#03#, 16#46#, 16#F9#,
      16#DF#, 16#E0#, 16#B2#, 16#EE#, 16#90#, 16#5D#, 16#CC#, 16#28#,
      16#8B#, 16#AF#, 16#4A#, 16#92#, 16#DE#, 16#3F#, 16#40#, 16#01#,
      16#DD#, 16#9F#, 16#44#, 16#C4#, 16#68#, 16#C3#, 16#D0#, 16#7D#,
      16#6C#, 16#6E#, 16#E8#, 16#2F#, 16#AC#, 16#EA#, 16#FC#, 16#97#,
      16#C2#, 16#FC#, 16#0F#, 16#C0#, 16#60#, 16#17#, 16#19#, 16#D2#,
      16#DC#, 16#D0#, 16#AA#, 16#2A#, 16#EC#, 16#92#, 16#D1#, 16#B0#,
      16#AE#, 16#93#, 16#3C#, 16#65#, 16#EB#, 16#06#, 16#A0#, 16#3C#,
      16#9C#, 16#93#, 16#5C#, 16#2B#, 16#AD#, 16#04#, 16#59#, 16#81#,
      16#02#, 16#41#, 16#34#, 16#7A#, 16#B8#, 16#7E#, 16#9F#, 16#11#,
      16#AD#, 16#B3#, 16#04#, 16#15#, 16#42#, 16#4C#, 16#6C#, 16#7F#,
      16#5F#, 16#22#, 16#A0#, 16#03#, 16#B8#, 16#AB#, 16#8D#, 16#E5#,
      16#4F#, 16#6D#, 16#ED#, 16#0E#, 16#3A#, 16#B9#, 16#24#, 16#5F#,
      16#A7#, 16#95#, 16#68#, 16#45#, 16#1D#, 16#FA#, 16#25#, 16#8E#
   );

   NIST_K45 : constant Byte_Seq := (
      16#F9#, 16#87#, 16#EB#, 16#83#, 16#A3#, 16#FD#, 16#6D#, 16#94#,
      16#EB#, 16#F3#, 16#62#, 16#6B#, 16#7D#, 16#34#, 16#FE#, 16#C2#,
      16#3E#, 16#E0#, 16#6C#, 16#63#, 16#DF#, 16#B4#, 16#07#, 16#8C#,
      16#B3#, 16#8B#, 16#CC#, 16#97#, 16#BD#, 16#25#, 16#0F#, 16#DA#,
      16#0E#, 16#28#, 16#6E#, 16#CD#, 16#4E#, 16#64#, 16#04#, 16#6A#,
      16#98#, 16#5B#, 16#DF#, 16#DA#, 16#8B#
     ); 


   NIST_D45 : constant Byte_Seq := (
      16#39#, 16#0A#, 16#9D#, 16#C2#, 16#EA#, 16#20#, 16#22#, 16#1C#,
      16#59#, 16#93#, 16#C5#, 16#81#, 16#89#, 16#2E#, 16#B4#, 16#B0#,
      16#43#, 16#64#, 16#29#, 16#4F#, 16#AD#, 16#91#, 16#9C#, 16#45#,
      16#1E#, 16#83#, 16#37#, 16#65#, 16#31#, 16#39#, 16#8A#, 16#4C#,
      16#18#, 16#EA#, 16#80#, 16#8C#, 16#33#, 16#4A#, 16#91#, 16#0A#,
      16#E1#, 16#08#, 16#3A#, 16#A4#, 16#97#, 16#9B#, 16#AA#, 16#17#,
      16#2F#, 16#3E#, 16#BF#, 16#20#, 16#82#, 16#39#, 16#30#, 16#E2#,
      16#38#, 16#63#, 16#0C#, 16#88#, 16#DF#, 16#E5#, 16#63#, 16#2B#,
      16#3B#, 16#40#, 16#42#, 16#F6#, 16#DD#, 16#92#, 16#E5#, 16#88#,
      16#F7#, 16#15#, 16#29#, 16#99#, 16#6F#, 16#E8#, 16#40#, 16#E1#,
      16#32#, 16#12#, 16#A8#, 16#35#, 16#CB#, 16#C4#, 16#5E#, 16#F4#,
      16#34#, 16#DE#, 16#4F#, 16#A1#, 16#EC#, 16#B5#, 16#0F#, 16#D1#,
      16#49#, 16#13#, 16#CD#, 16#48#, 16#10#, 16#80#, 16#87#, 16#5F#,
      16#43#, 16#C0#, 16#7A#, 16#A9#, 16#3A#, 16#9D#, 16#DD#, 16#D5#,
      16#F5#, 16#E7#, 16#CE#, 16#D6#, 16#B1#, 16#B8#, 16#8D#, 16#42#,
      16#B9#, 16#FC#, 16#E8#, 16#F8#, 16#7F#, 16#31#, 16#F6#, 16#06#
   );

   NIST_K60 : constant Byte_Seq := (
      16#91#, 16#17#, 16#CF#, 16#3C#, 16#E9#, 16#F5#, 16#C6#, 16#E1#,
      16#97#, 16#52#, 16#BF#, 16#0B#, 16#1C#, 16#F8#, 16#6A#, 16#78#,
      16#CE#, 16#3A#, 16#DB#, 16#BA#, 16#87#, 16#DA#, 16#E1#, 16#39#,
      16#9A#, 16#2A#, 16#93#, 16#7B#, 16#0B#, 16#72#, 16#2B#, 16#A3#,
      16#FF#, 16#92#, 16#18#, 16#38#, 16#71#, 16#E8#, 16#4E#, 16#28#,
      16#27#, 16#74#, 16#E1#, 16#0D#, 16#E4#
   );

   NIST_D60 : constant Byte_Seq := (
      16#93#, 16#5A#, 16#3C#, 16#27#, 16#24#, 16#9D#, 16#CF#, 16#92#,
      16#AE#, 16#DA#, 16#C8#, 16#DC#, 16#76#, 16#D2#, 16#2F#, 16#F7#,
      16#74#, 16#2E#, 16#5C#, 16#EE#, 16#57#, 16#71#, 16#17#, 16#78#,
      16#C9#, 16#2A#, 16#FD#, 16#CD#, 16#F3#, 16#6E#, 16#26#, 16#B8#,
      16#44#, 16#85#, 16#04#, 16#EE#, 16#6E#, 16#E4#, 16#8E#, 16#9E#,
      16#B2#, 16#5B#, 16#9E#, 16#49#, 16#5E#, 16#90#, 16#98#, 16#D4#,
      16#94#, 16#AC#, 16#4D#, 16#DC#, 16#4C#, 16#54#, 16#1F#, 16#49#,
      16#9C#, 16#DB#, 16#65#, 16#26#, 16#38#, 16#B6#, 16#11#, 16#B0#,
      16#35#, 16#30#, 16#90#, 16#AC#, 16#12#, 16#5F#, 16#F1#, 16#FE#,
      16#F8#, 16#56#, 16#4A#, 16#78#, 16#41#, 16#9C#, 16#57#, 16#F0#,
      16#38#, 16#DD#, 16#65#, 16#95#, 16#1F#, 16#E0#, 16#6E#, 16#83#,
      16#77#, 16#B9#, 16#86#, 16#94#, 16#7B#, 16#40#, 16#75#, 16#79#,
      16#EE#, 16#C1#, 16#A6#, 16#0A#, 16#16#, 16#F5#, 16#40#, 16#DB#,
      16#09#, 16#31#, 16#92#, 16#10#, 16#27#, 16#DE#, 16#B4#, 16#72#,
      16#E8#, 16#29#, 16#6B#, 16#C2#, 16#D8#, 16#FB#, 16#4E#, 16#4D#,
      16#DF#, 16#2C#, 16#27#, 16#C0#, 16#C6#, 16#F4#, 16#9C#, 16#3E#
   );

   NIST_K75 : constant Byte_Seq := (
      16#B7#, 16#63#, 16#26#, 16#3D#, 16#C4#, 16#FC#, 16#62#, 16#B2#,
      16#27#, 16#CD#, 16#3F#, 16#6B#, 16#4E#, 16#9E#, 16#35#, 16#8C#,
      16#21#, 16#CA#, 16#03#, 16#6C#, 16#E3#, 16#96#, 16#AB#, 16#92#,
      16#59#, 16#C1#, 16#BE#, 16#DD#, 16#2F#, 16#5C#, 16#D9#, 16#02#,
      16#97#, 16#DC#, 16#70#, 16#3C#, 16#33#, 16#6E#, 16#CA#, 16#3E#,
      16#35#, 16#8A#, 16#4D#, 16#6D#, 16#C5#
     );

   NIST_D75 : constant Byte_Seq := (
      16#53#, 16#CB#, 16#09#, 16#D0#, 16#A7#, 16#88#, 16#E4#, 16#46#,
      16#6D#, 16#01#, 16#58#, 16#8D#, 16#F6#, 16#94#, 16#5D#, 16#87#,
      16#28#, 16#D9#, 16#36#, 16#3F#, 16#76#, 16#CD#, 16#01#, 16#2A#,
      16#10#, 16#30#, 16#8D#, 16#AD#, 16#56#, 16#2B#, 16#6B#, 16#E0#,
      16#93#, 16#36#, 16#48#, 16#92#, 16#E8#, 16#39#, 16#7A#, 16#8D#,
      16#86#, 16#F1#, 16#D8#, 16#1A#, 16#20#, 16#96#, 16#CF#, 16#C8#,
      16#A1#, 16#BB#, 16#B2#, 16#6A#, 16#1A#, 16#75#, 16#52#, 16#5F#,
      16#FE#, 16#BF#, 16#CF#, 16#16#, 16#91#, 16#1D#, 16#AD#, 16#D0#,
      16#9E#, 16#80#, 16#2A#, 16#A8#, 16#68#, 16#6A#, 16#CF#, 16#D1#,
      16#E4#, 16#52#, 16#46#, 16#20#, 16#25#, 16#4A#, 16#6B#, 16#CA#,
      16#18#, 16#DF#, 16#A5#, 16#6E#, 16#71#, 16#41#, 16#77#, 16#56#,
      16#E5#, 16#A4#, 16#52#, 16#FA#, 16#9A#, 16#E5#, 16#AE#, 16#C5#,
      16#DC#, 16#71#, 16#59#, 16#1C#, 16#11#, 16#63#, 16#0E#, 16#9D#,
      16#EF#, 16#EC#, 16#49#, 16#A4#, 16#EC#, 16#F8#, 16#5A#, 16#14#,
      16#F6#, 16#0E#, 16#B8#, 16#54#, 16#65#, 16#78#, 16#99#, 16#97#,
      16#2E#, 16#A5#, 16#BF#, 16#61#, 16#59#, 16#CB#, 16#95#, 16#47#
   );

   NIST_K90 : constant Byte_Seq := (
      16#79#, 16#F8#, 16#77#, 16#34#, 16#C4#, 16#6C#, 16#5A#, 16#11#,
      16#D8#, 16#6A#, 16#ED#, 16#EA#, 16#D2#, 16#2E#, 16#D3#, 16#EA#,
      16#01#, 16#57#, 16#7A#, 16#D4#, 16#EC#, 16#DF#, 16#42#, 16#96#,
      16#96#, 16#50#, 16#E1#, 16#20#, 16#00#, 16#35#, 16#06#, 16#76#,
      16#F0#, 16#CF#, 16#3C#, 16#04#, 16#F1#, 16#0A#, 16#11#, 16#33#,
      16#9B#, 16#AF#, 16#78#, 16#39#, 16#14#, 16#DB#, 16#6D#, 16#35#,
      16#D7#, 16#B0#, 16#D7#, 16#7B#, 16#B4#, 16#4A#, 16#B2#, 16#2C#,
      16#18#, 16#F5#, 16#6D#, 16#0B#, 16#8F#, 16#9D#, 16#91#, 16#8B#
   );

   NIST_D90 : constant Byte_Seq := (
      16#50#, 16#9A#, 16#0A#, 16#45#, 16#A1#, 16#51#, 16#2B#, 16#50#,
      16#72#, 16#47#, 16#4B#, 16#29#, 16#7F#, 16#9C#, 16#1A#, 16#8C#,
      16#24#, 16#89#, 16#00#, 16#16#, 16#14#, 16#44#, 16#68#, 16#50#,
      16#4E#, 16#24#, 16#5F#, 16#E9#, 16#4D#, 16#06#, 16#5D#, 16#43#,
      16#7F#, 16#EF#, 16#62#, 16#32#, 16#F9#, 16#F3#, 16#45#, 16#00#,
      16#69#, 16#55#, 16#49#, 16#B4#, 16#4C#, 16#EF#, 16#F2#, 16#93#,
      16#61#, 16#D4#, 16#17#, 16#E8#, 16#5D#, 16#35#, 16#37#, 16#01#,
      16#E0#, 16#81#, 16#11#, 16#7A#, 16#A8#, 16#D0#, 16#6E#, 16#BE#,
      16#05#, 16#82#, 16#42#, 16#CA#, 16#8C#, 16#23#, 16#F3#, 16#34#,
      16#10#, 16#92#, 16#F9#, 16#6C#, 16#CE#, 16#63#, 16#A7#, 16#43#,
      16#E8#, 16#81#, 16#48#, 16#A9#, 16#15#, 16#18#, 16#6E#, 16#BB#,
      16#96#, 16#B2#, 16#87#, 16#FD#, 16#6C#, 16#A0#, 16#B1#, 16#E3#,
      16#C8#, 16#9B#, 16#D0#, 16#97#, 16#C3#, 16#AB#, 16#DD#, 16#F6#,
      16#4F#, 16#48#, 16#81#, 16#DB#, 16#6D#, 16#BF#, 16#E2#, 16#A1#,
      16#A1#, 16#D8#, 16#BD#, 16#E3#, 16#A3#, 16#B6#, 16#B5#, 16#86#,
      16#58#, 16#FE#, 16#EA#, 16#FA#, 16#00#, 16#3C#, 16#CE#, 16#BC#
   );

   NIST_K105 : constant Byte_Seq := (
      16#A5#, 16#FD#, 16#99#, 16#CA#, 16#57#, 16#C1#, 16#FE#, 16#C8#,
      16#15#, 16#9A#, 16#79#, 16#87#, 16#92#, 16#42#, 16#6D#, 16#29#,
      16#6F#, 16#A1#, 16#B1#, 16#7D#, 16#53#, 16#92#, 16#41#, 16#DE#,
      16#3D#, 16#EA#, 16#33#, 16#58#, 16#19#, 16#B7#, 16#ED#, 16#0D#,
      16#92#, 16#C5#, 16#96#, 16#D7#, 16#28#, 16#67#, 16#CA#, 16#2F#,
      16#82#, 16#73#, 16#92#, 16#4E#, 16#05#, 16#8F#, 16#93#, 16#91#,
      16#A5#, 16#AB#, 16#85#, 16#22#, 16#FB#, 16#CF#, 16#E7#, 16#D5#,
      16#98#, 16#17#, 16#F1#, 16#50#, 16#9A#, 16#FC#, 16#CB#, 16#6F#
   );

   NIST_D105 : constant Byte_Seq := (
      16#5C#, 16#F3#, 16#A5#, 16#20#, 16#2D#, 16#F8#, 16#70#, 16#6F#,
      16#6B#, 16#FF#, 16#5B#, 16#F2#, 16#59#, 16#0D#, 16#E3#, 16#7C#,
      16#90#, 16#2C#, 16#7F#, 16#FD#, 16#4E#, 16#6C#, 16#8E#, 16#A6#,
      16#11#, 16#28#, 16#8E#, 16#4E#, 16#65#, 16#8A#, 16#8E#, 16#15#,
      16#FA#, 16#51#, 16#E6#, 16#47#, 16#F9#, 16#D2#, 16#25#, 16#83#,
      16#98#, 16#3D#, 16#4B#, 16#1C#, 16#ED#, 16#22#, 16#39#, 16#BF#,
      16#FF#, 16#34#, 16#65#, 16#56#, 16#23#, 16#4C#, 16#D2#, 16#2D#,
      16#86#, 16#B1#, 16#40#, 16#53#, 16#06#, 16#96#, 16#A0#, 16#44#,
      16#46#, 16#E4#, 16#CA#, 16#C4#, 16#01#, 16#3A#, 16#72#, 16#0E#,
      16#9E#, 16#32#, 16#58#, 16#2E#, 16#05#, 16#E7#, 16#C0#, 16#AC#,
      16#B2#, 16#B4#, 16#22#, 16#6A#, 16#07#, 16#3E#, 16#22#, 16#CF#,
      16#E7#, 16#B4#, 16#C2#, 16#25#, 16#80#, 16#55#, 16#D7#, 16#40#,
      16#68#, 16#33#, 16#BA#, 16#61#, 16#EC#, 16#37#, 16#3F#, 16#5A#,
      16#A5#, 16#66#, 16#EB#, 16#F2#, 16#4C#, 16#62#, 16#61#, 16#8A#,
      16#CE#, 16#34#, 16#1E#, 16#01#, 16#A3#, 16#48#, 16#66#, 16#D6#,
      16#5C#, 16#B9#, 16#7E#, 16#8C#, 16#7C#, 16#D0#, 16#1C#, 16#53#
   );

   NIST_K120 : constant Byte_Seq := (
      16#99#, 16#28#, 16#68#, 16#50#, 16#4D#, 16#25#, 16#64#, 16#C4#,
      16#FB#, 16#47#, 16#BC#, 16#BD#, 16#4A#, 16#E4#, 16#82#, 16#D8#,
      16#FB#, 16#0E#, 16#8E#, 16#56#, 16#D7#, 16#B8#, 16#18#, 16#64#,
      16#E6#, 16#19#, 16#86#, 16#A0#, 16#E2#, 16#56#, 16#82#, 16#DA#,
      16#EB#, 16#5B#, 16#50#, 16#17#, 16#7C#, 16#09#, 16#5E#, 16#DC#,
      16#9E#, 16#97#, 16#1D#, 16#A9#, 16#5C#, 16#32#, 16#10#, 16#C3#,
      16#76#, 16#E7#, 16#23#, 16#36#, 16#5A#, 16#C3#, 16#3D#, 16#1B#,
      16#4F#, 16#39#, 16#18#, 16#17#, 16#F4#, 16#C3#, 16#51#, 16#24#
   );

   NIST_D120 : constant Byte_Seq := (
      16#ED#, 16#4F#, 16#26#, 16#9A#, 16#88#, 16#51#, 16#EB#, 16#31#,
      16#54#, 16#77#, 16#15#, 16#16#, 16#B2#, 16#72#, 16#28#, 16#15#,
      16#52#, 16#00#, 16#77#, 16#80#, 16#49#, 16#B2#, 16#DC#, 16#19#,
      16#63#, 16#F3#, 16#AC#, 16#32#, 16#BA#, 16#46#, 16#EA#, 16#13#,
      16#87#, 16#CF#, 16#BB#, 16#9C#, 16#39#, 16#15#, 16#1A#, 16#2C#,
      16#C4#, 16#06#, 16#CD#, 16#C1#, 16#3C#, 16#3C#, 16#98#, 16#60#,
      16#A2#, 16#7E#, 16#B0#, 16#B7#, 16#FE#, 16#8A#, 16#72#, 16#01#,
      16#AD#, 16#11#, 16#55#, 16#2A#, 16#FD#, 16#04#, 16#1E#, 16#33#,
      16#F7#, 16#0E#, 16#53#, 16#D9#, 16#7C#, 16#62#, 16#F1#, 16#71#,
      16#94#, 16#B6#, 16#61#, 16#17#, 16#02#, 16#8F#, 16#A9#, 16#07#,
      16#1C#, 16#C0#, 16#E0#, 16#4B#, 16#D9#, 16#2D#, 16#E4#, 16#97#,
      16#2C#, 16#D5#, 16#4F#, 16#71#, 16#90#, 16#10#, 16#A6#, 16#94#,
      16#E4#, 16#14#, 16#D4#, 16#97#, 16#7A#, 16#BE#, 16#D7#, 16#CA#,
      16#6B#, 16#90#, 16#BA#, 16#61#, 16#2D#, 16#F6#, 16#C3#, 16#D4#,
      16#67#, 16#CD#, 16#ED#, 16#85#, 16#03#, 16#25#, 16#98#, 16#A4#,
      16#85#, 16#46#, 16#80#, 16#4F#, 16#9C#, 16#F2#, 16#EC#, 16#FE#
   );

   NIST_K135 : constant Byte_Seq := (
      16#07#, 16#C3#, 16#58#, 16#ED#, 16#1D#, 16#F3#, 16#B0#, 16#6D#, 
      16#47#, 16#B5#, 16#EC#, 16#76#, 16#3A#, 16#FA#, 16#07#, 16#A6#, 
      16#67#, 16#7C#, 16#A3#, 16#A7#, 16#22#, 16#52#, 16#4E#, 16#61#, 
      16#03#, 16#C1#, 16#05#, 16#6D#, 16#8C#, 16#56#, 16#F6#, 16#CD#, 
      16#0D#, 16#31#, 16#8A#, 16#DB#, 16#C5#, 16#A4#, 16#A3#, 16#80#, 
      16#4A#, 16#FD#, 16#23#, 16#A6#, 16#2B#, 16#9F#, 16#AD#, 16#F0#, 
      16#D3#, 16#58#, 16#AF#, 16#A8#, 16#B0#, 16#EE#, 16#A0#, 16#F9#, 
      16#95#, 16#FB#, 16#86#, 16#5E#, 16#5D#, 16#FB#, 16#BC#, 16#5A#, 
      16#D2#, 16#A4#, 16#F2#, 16#6A#, 16#CD#, 16#76# 
   );

   NIST_D135 : constant Byte_Seq := (
      16#2A#, 16#A1#, 16#D9#, 16#4E#, 16#C8#, 16#3C#, 16#E7#, 16#C3#, 
      16#C7#, 16#5C#, 16#6B#, 16#C8#, 16#47#, 16#75#, 16#9B#, 16#08#, 
      16#52#, 16#34#, 16#FD#, 16#44#, 16#B4#, 16#07#, 16#D8#, 16#F8#, 
      16#0D#, 16#DF#, 16#E9#, 16#3C#, 16#24#, 16#35#, 16#56#, 16#E8#, 
      16#7E#, 16#4B#, 16#E8#, 16#FB#, 16#30#, 16#B4#, 16#74#, 16#3E#, 
      16#F1#, 16#16#, 16#9A#, 16#24#, 16#73#, 16#2F#, 16#B2#, 16#F5#, 
      16#F4#, 16#16#, 16#04#, 16#2B#, 16#10#, 16#C3#, 16#37#, 16#1D#, 
      16#D9#, 16#D2#, 16#0D#, 16#DA#, 16#29#, 16#84#, 16#4D#, 16#58#, 
      16#37#, 16#07#, 16#00#, 16#CE#, 16#69#, 16#F7#, 16#DF#, 16#5E#, 
      16#69#, 16#24#, 16#0D#, 16#F7#, 16#7B#, 16#96#, 16#02#, 16#7A#, 
      16#0E#, 16#CE#, 16#C7#, 16#1B#, 16#90#, 16#4F#, 16#69#, 16#0B#, 
      16#87#, 16#5D#, 16#A8#, 16#54#, 16#DE#, 16#05#, 16#EF#, 16#04#, 
      16#7C#, 16#5D#, 16#89#, 16#8D#, 16#1C#, 16#0D#, 16#11#, 16#6C#, 
      16#58#, 16#0E#, 16#2A#, 16#09#, 16#06#, 16#B2#, 16#71#, 16#DE#, 
      16#C8#, 16#E5#, 16#B0#, 16#DC#, 16#DF#, 16#B2#, 16#55#, 16#0A#, 
      16#40#, 16#09#, 16#22#, 16#70#, 16#EA#, 16#BF#, 16#25#, 16#33# 
   );

   D : Bytes_32;
begin

   HMAC_SHA_256 (D, Data1, Key1);
   DH ("D1 is", D);

   HMAC_SHA_256 (D, Data2, Key2);
   DH ("D2 is", D);

   HMAC_SHA_256 (D, Data3, Key3);
   DH ("D3 is", D);
   
   HMAC_SHA_256 (D, Data4, Key4);
   DH ("D4 is", D);

   HMAC_SHA_256 (D, Data5, Key5);
   DH ("D5 is", D (0 .. 15));
   
   HMAC_SHA_256 (D, Data6, Key6);
   DH ("D6 is", D);
   
   HMAC_SHA_256 (D, Data7, Key7);
   DH ("D7 is", D);

   HMAC_SHA_256 (D, NIST_D0, NIST_K0);
   DH ("NIST Count 0 is", D (0 .. 15));
   
   HMAC_SHA_256 (D, NIST_D1, NIST_K1);
   DH ("NIST Count 1 is", D (0 .. 15));
   
   HMAC_SHA_256 (D, NIST_D2, NIST_K2);
   DH ("NIST Count 2 is", D (0 .. 15));
   
   HMAC_SHA_256 (D, NIST_D3, NIST_K3);
   DH ("NIST Count 3 is", D (0 .. 15));
   
   HMAC_SHA_256 (D, NIST_D4, NIST_K4);
   DH ("NIST Count 4 is", D (0 .. 15));
   
   HMAC_SHA_256 (D, NIST_D15, NIST_K15);
   DH ("NIST Count 15 is", D (0 .. 23));
   
   HMAC_SHA_256 (D, NIST_D30, NIST_K30);
   DH ("NIST Count 30 is", D);
   
   HMAC_SHA_256 (D, NIST_D45, NIST_K45);
   DH ("NIST Count 45 is", D (0 .. 15));
   
   HMAC_SHA_256 (D, NIST_D60, NIST_K60);
   DH ("NIST Count 60 is", D (0 .. 23));
   
   HMAC_SHA_256 (D, NIST_D75, NIST_K75);
   DH ("NIST Count 75 is", D);
   
   HMAC_SHA_256 (D, NIST_D90, NIST_K90);
   DH ("NIST Count 90 is", D (0 .. 15));
   
   HMAC_SHA_256 (D, NIST_D105, NIST_K105);
   DH ("NIST Count 105 is", D (0 .. 23));
   
   HMAC_SHA_256 (D, NIST_D120, NIST_K120);
   DH ("NIST Count 120 is", D);

   HMAC_SHA_256 (D, NIST_D135, NIST_K135);
   DH ("NIST Count 135 is", D (0 .. 15));
end HMAC;
