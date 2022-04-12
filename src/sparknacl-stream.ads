with SPARKNaCl.Core; use SPARKNaCl.Core;
package SPARKNaCl.Stream
  with Pure,
       SPARK_Mode => On
is
   --  Distinct from Bytes_32, but both inherit Equal,
   --  Random_Bytes, and Sanitize primitive operations.
   type HSalsa20_Nonce is new Bytes_24;
   type Salsa20_Nonce  is new Bytes_8;

   --------------------------------------------------------
   --  Secret key encryption (not authenticated)
   --------------------------------------------------------

   procedure HSalsa20 (C :    out Byte_Seq;       --  Output stream
                       N : in     HSalsa20_Nonce; --  Nonce
                       K : in     Salsa20_Key)    --  Key
     with Global => null,
          Pre    => C'First = 0;


   procedure HSalsa20_Xor (C :    out Byte_Seq; --  Output ciphertext
                           M : in     Byte_Seq; --  Input message
                           N : in     HSalsa20_Nonce; --  Nonce
                           K : in     Salsa20_Key)    --  Key
     with Global => null,
          Pre    => M'First = 0 and
                    C'First = 0 and
                    C'Last  = M'Last;

   procedure Salsa20 (C :    out Byte_Seq; --  Output stream
                      N : in     Salsa20_Nonce; --  Nonce
                      K : in     Salsa20_Key)    --  Key
     with Global => null,
          Pre    => C'First = 0;

   procedure Salsa20_Xor (C :    out Byte_Seq; --  Output stream
                          M : in     Byte_Seq; --  Input message
                          N : in     Salsa20_Nonce; --  Nonce
                          K : in     Salsa20_Key)    --  Key
     with Global => null,
          Pre    => M'First = 0 and
                    C'First = 0 and
                    C'Last  = M'Last;

   ---------------------------------------------------------
   --  ChaCha20
   ---------------------------------------------------------

   procedure ChaCha20 (C       :    out Byte_Seq;       -- Output stream
                       N       : in     ChaCha20_Nonce; -- Nonce
                       K       : in     ChaCha20_Key;   -- Key
                       Counter : in     U64)            -- Initial Counter
     with Global => null,
          Pre    => C'First = 0 and
                    U32 (C'Length) <= U32 (N32'Last);

   procedure ChaCha20_Xor (C       :    out Byte_Seq;  -- Output stream
                           M       : in     Byte_Seq;  -- Input message
                           N       : in     ChaCha20_Nonce; -- Nonce
                           K       : in     ChaCha20_Key;   -- Key
                           Counter : in     U64)
     with Global => null,
          Pre    => M'First = 0 and
                    C'First = 0 and
                    C'Last  = M'Last and
                    U32 (C'Length) <= U32 (N32'Last);

   ---------------------------------------------------------
   --  ChaCha20 IETF variant
   ---------------------------------------------------------

   procedure ChaCha20_IETF (C       :    out Byte_Seq;       -- Output stream
                            N       : in     ChaCha20_IETF_Nonce; -- Nonce
                            K       : in     ChaCha20_Key;   -- Key
                            Counter : in     U32)
     with Global => null,
          Pre    => C'First = 0 and
                    U32 (C'Length) <= U32 (N32'Last);

   procedure ChaCha20_IETF_Xor (C       :    out Byte_Seq;  -- Output stream
                                M       : in     Byte_Seq;  -- Input message
                                N       : in     ChaCha20_IETF_Nonce; -- Nonce
                                K       : in     ChaCha20_Key;        -- Key
                                Counter : in     U32)
     with Global => null,
          Pre    => M'First = 0 and
                    C'First = 0 and
                    C'Last  = M'Last and
                    U32 (C'Length) <= U32 (N32'Last);

end SPARKNaCl.Stream;
