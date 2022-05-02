with SPARKNaCl;           use SPARKNaCl;
with SPARKNaCl.Core;      use SPARKNaCl.Core;
with SPARKNaCl.Debug;     use SPARKNaCl.Debug;
with SPARKNaCl.Secretbox; use SPARKNaCl.Secretbox;
with SPARKNaCl.Stream;
with Ada.Text_IO;         use Ada.Text_IO;

procedure Secretbox10
is
   --------------------------------------------------------
   --  Test Cases from RFC 8439
   --------------------------------------------------------

   --  Case 1: Message encryption and generation of tag

   Key_1 : constant Core.ChaCha20_Key := Construct ((
      16#80#, 16#81#, 16#82#, 16#83#, 16#84#, 16#85#, 16#86#, 16#87#,
      16#88#, 16#89#, 16#8a#, 16#8b#, 16#8c#, 16#8d#, 16#8e#, 16#8f#,
      16#90#, 16#91#, 16#92#, 16#93#, 16#94#, 16#95#, 16#96#, 16#97#,
      16#98#, 16#99#, 16#9a#, 16#9b#, 16#9c#, 16#9d#, 16#9e#, 16#9f#
   ));

   --  In AEAD, nonce := constant & iv
   --  constant: 07 00 00 00
   --  IV: 40 41 42 43 44 45 46 47
   Nonce_1 : constant Core.ChaCha20_IETF_Nonce := (
      16#07#, 16#00#, 16#00#, 16#00#, 16#40#, 16#41#, 16#42#, 16#43#,
      16#44#, 16#45#, 16#46#, 16#47#);

   M_1 : constant Byte_Seq (0 .. 113) := SPARKNaCl.To_Byte_Seq (
      "Ladies and Gentlemen of the class of '99: If I could offer you only" &
      " one tip for the future, sunscreen would be it.");

   AAD_1 : Byte_Seq := (
      16#50#, 16#51#, 16#52#, 16#53#, 16#C0#, 16#C1#, 16#C2#, 16#C3#,
      16#C4#, 16#C5#, 16#C6#, 16#C7#);

   C_1   : Byte_Seq (0 .. 113);
   T_1   : Bytes_16;

   --  Case 2: Verification of tag and message decryption

   Key_2 : constant Core.ChaCha20_Key := Construct ((
      16#1C#, 16#92#, 16#40#, 16#A5#, 16#EB#, 16#55#, 16#D3#, 16#8A#,
      16#F3#, 16#33#, 16#88#, 16#86#, 16#04#, 16#F6#, 16#B5#, 16#F0#,
      16#47#, 16#39#, 16#17#, 16#C1#, 16#40#, 16#2B#, 16#80#, 16#09#,
      16#9D#, 16#CA#, 16#5C#, 16#BC#, 16#20#, 16#70#, 16#75#, 16#C0#
   ));

   C_2   : constant Byte_Seq := (
      16#64#, 16#A0#, 16#86#, 16#15#, 16#75#, 16#86#, 16#1A#, 16#F4#, 
      16#60#, 16#F0#, 16#62#, 16#C7#, 16#9B#, 16#E6#, 16#43#, 16#BD#,
      16#5E#, 16#80#, 16#5C#, 16#FD#, 16#34#, 16#5C#, 16#F3#, 16#89#, 
      16#F1#, 16#08#, 16#67#, 16#0A#, 16#C7#, 16#6C#, 16#8C#, 16#B2#,
      16#4C#, 16#6C#, 16#FC#, 16#18#, 16#75#, 16#5D#, 16#43#, 16#EE#, 
      16#A0#, 16#9E#, 16#E9#, 16#4E#, 16#38#, 16#2D#, 16#26#, 16#B0#,
      16#BD#, 16#B7#, 16#B7#, 16#3C#, 16#32#, 16#1B#, 16#01#, 16#00#, 
      16#D4#, 16#F0#, 16#3B#, 16#7F#, 16#35#, 16#58#, 16#94#, 16#CF#,
      16#33#, 16#2F#, 16#83#, 16#0E#, 16#71#, 16#0B#, 16#97#, 16#CE#, 
      16#98#, 16#C8#, 16#A8#, 16#4A#, 16#BD#, 16#0B#, 16#94#, 16#81#,
      16#14#, 16#AD#, 16#17#, 16#6E#, 16#00#, 16#8D#, 16#33#, 16#BD#, 
      16#60#, 16#F9#, 16#82#, 16#B1#, 16#FF#, 16#37#, 16#C8#, 16#55#,
      16#97#, 16#97#, 16#A0#, 16#6E#, 16#F4#, 16#F0#, 16#EF#, 16#61#, 
      16#C1#, 16#86#, 16#32#, 16#4E#, 16#2B#, 16#35#, 16#06#, 16#38#,
      16#36#, 16#06#, 16#90#, 16#7B#, 16#6A#, 16#7C#, 16#02#, 16#B0#, 
      16#F9#, 16#F6#, 16#15#, 16#7B#, 16#53#, 16#C8#, 16#67#, 16#E4#,
      16#B9#, 16#16#, 16#6C#, 16#76#, 16#7B#, 16#80#, 16#4D#, 16#46#, 
      16#A5#, 16#9B#, 16#52#, 16#16#, 16#CD#, 16#E7#, 16#A4#, 16#E9#,
      16#90#, 16#40#, 16#C5#, 16#A4#, 16#04#, 16#33#, 16#22#, 16#5E#, 
      16#E2#, 16#82#, 16#A1#, 16#B0#, 16#A0#, 16#6C#, 16#52#, 16#3E#,
      16#AF#, 16#45#, 16#34#, 16#D7#, 16#F8#, 16#3F#, 16#A1#, 16#15#, 
      16#5B#, 16#00#, 16#47#, 16#71#, 16#8C#, 16#BC#, 16#54#, 16#6A#,
      16#0D#, 16#07#, 16#2B#, 16#04#, 16#B3#, 16#56#, 16#4E#, 16#EA#, 
      16#1B#, 16#42#, 16#22#, 16#73#, 16#F5#, 16#48#, 16#27#, 16#1A#,
      16#0B#, 16#B2#, 16#31#, 16#60#, 16#53#, 16#FA#, 16#76#, 16#99#, 
      16#19#, 16#55#, 16#EB#, 16#D6#, 16#31#, 16#59#, 16#43#, 16#4E#,
      16#CE#, 16#BB#, 16#4E#, 16#46#, 16#6D#, 16#AE#, 16#5A#, 16#10#, 
      16#73#, 16#A6#, 16#72#, 16#76#, 16#27#, 16#09#, 16#7A#, 16#10#,
      16#49#, 16#E6#, 16#17#, 16#D9#, 16#1D#, 16#36#, 16#10#, 16#94#, 
      16#FA#, 16#68#, 16#F0#, 16#FF#, 16#77#, 16#98#, 16#71#, 16#30#,
      16#30#, 16#5B#, 16#EA#, 16#BA#, 16#2E#, 16#DA#, 16#04#, 16#DF#, 
      16#99#, 16#7B#, 16#71#, 16#4D#, 16#6C#, 16#6F#, 16#2C#, 16#29#,
      16#A6#, 16#AD#, 16#5C#, 16#B4#, 16#02#, 16#2B#, 16#02#, 16#70#, 
      16#9B# );

   N_2   : constant Core.ChaCha20_IETF_Nonce := (
      16#00#, 16#00#, 16#00#, 16#00#, 16#01#, 16#02#, 16#03#, 16#04#,
      16#05#, 16#06#, 16#07#, 16#08#
   );

   AAD_2 : constant Byte_Seq := (
      16#F3#, 16#33#, 16#88#, 16#86#, 16#00#, 16#00#, 16#00#, 16#00#,
      16#00#, 16#00#, 16#4E#, 16#91#
   );

   Tag_2 : constant Byte_Seq := (
      16#EE#, 16#AD#, 16#9D#, 16#67#, 16#89#, 16#0C#, 16#BB#, 16#22#,
      16#39#, 16#23#, 16#36#, 16#FE#, 16#A1#, 16#85#, 16#1F#, 16#38#
   );

   --  Test tag verification (not part of the RFC test suite)
   Bad_Tag_2 : constant Bytes_16 := (others => 16#AA#);

   M_2 : Byte_Seq (C_2'Range);
   S_2 : Boolean;
begin
   Create (C_1, T_1, M_1, Nonce_1, Key_1, AAD_1, 1);
   DH ("C_1 is", C_1);
   DH ("T_1 is", T_1);

   Open (M_2, S_2, Tag_2, C_2, N_2, Key_2, AAD_2, 1);
   Ada.Text_IO.Put_Line ("Verified: " & S_2'Image);
   DH ("M_2 is", M_2);

   Open (M_2, S_2, Bad_Tag_2, C_2, N_2, Key_2, AAD_2, 1);
   Ada.Text_IO.Put_Line ("Verified: " & S_2'Image);
end Secretbox10;
