with AES128_Cipher_Composition;
with AES128_Cipher_KAT;
with AES256_Cipher_Composition;
with AES256_Cipher_KAT;
with RFSB509_SUPERCOP_Regression;
with Hash;
with Hash1;
with Hash2;
with Box;
with Box7;
with Box8;
with Core1;
with Core3;
with ECDH;
with Onetimeauth;
with Onetimeauth2;
with Onetimeauth7;
with HMAC;
with HKDF1;
with Scalarmult;
with Scalarmult2;
with Scalarmult5;
with Scalarmult6;
with Secretbox;
with Secretbox2;
with Secretbox3;
with Secretbox7;
with Secretbox8;
with Secretbox9;
with Secretbox10;
with Sign;
with Stream;
with Stream2;
with Stream3;
with Stream4;
with Stream5;
with Stream6;
with Stream7;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions; use Ada.Exceptions;
with GNAT.Traceback.Symbolic; use GNAT.Traceback.Symbolic;

procedure Testall
is
begin
   Put_Line ("AES128 Cipher Composition");
   AES128_Cipher_Composition;
   Put_Line ("AES128 Cipher KAT");
   AES128_Cipher_KAT;
   Put_Line ("AES256 Cipher Composition");
   AES256_Cipher_Composition;
   Put_Line ("AES256 Cipher KAT");
   AES256_Cipher_KAT;
   Put_Line ("RFSB509 SUPERCOP Regression"); 
   RFSB509_SUPERCOP_Regression;
   Put_Line ("Hash");
   Hash;
   Put_Line ("Hash1");
   Hash1;
   Put_Line ("Hash2");
   Hash2;
   Put_Line ("Box");
   Box;
   Put_Line ("Box7");
   Box7;
   Put_Line ("Box8");
   Box8;
   Put_Line ("Core1");
   Core1;
   Put_Line ("Core3");
   Core3;
   Put_Line ("Onetimeauth");
   Onetimeauth;
   Put_Line ("Onetimeauth2");
   Onetimeauth2;
   Put_Line ("Onetimeauth7");
   Onetimeauth7;
   Put_Line ("HMAC");
   HMAC;
   Put_Line ("Scalarmult");
   Scalarmult;
   Put_Line ("Scalarmult2");
   Scalarmult2;
   Put_Line ("Scalarmult5");
   Scalarmult5;
   Put_Line ("Scalarmult6");
   Scalarmult6;
   Put_Line ("Secretbox");
   Secretbox;
   Put_Line ("Secretbox2");
   Secretbox2;
   Put_Line ("Secretbox3");
   Secretbox3;
   Put_Line ("Secretbox7");
   Secretbox7;
   Put_Line ("Secretbox8");
   Secretbox8;
   Put_Line ("Secretbox9");
   Secretbox9;
   Put_Line ("Secretbox10");
   Secretbox10;
   Put_Line ("Sign");
   Sign;
   Put_Line ("Stream");
   Stream;
   Put_Line ("Stream2");
   Stream2;
   Put_Line ("Stream3");
   Stream3;
   Put_Line ("Stream4");
   Stream4;
   Put_Line ("Stream5");
   Stream5;
   Put_Line ("Stream6");
   Stream6;
   Put_Line ("Stream7");
   Stream7;
   Put_Line ("ECDH");
   ECDH;
   Put_Line ("HKDF");
   HKDF1;
exception
   when E : others =>
      Put_Line (Exception_Message (E));
      Put_Line (Exception_Information (E));
      Put_Line (Symbolic_Traceback (E));
end Testall;
