// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Curve.sol";
import "./Schnorr.sol";

/*
This implements AOS 1-out-of-n ring signature which require only `n+1`
scalars to validate in addition to the `n` public keys.
''Intuitively, this scheme is a ring of Schnorr signatures where each
challenge is taken from the previous step. Indeed, it is the Schnorr
signature scheme where n=1''
For more information, see:
 - https://www.iacr.org/cryptodb/archive/2002/ASIACRYPT/50/50.pdf
When verifying the ring only the initial aos_e value for `c` is provided
instead of supplying a value of `c` for each link in the ring. The hash
of the previous link is used as the next value of `c`.
The ring is successfully verified if the last value of `c` matches the
aos_e value.
For more information on turning this scheme into a linkable ring:
 - https://bitcointalk.org/index.php?topic=972541.msg10619684#msg10619684
 - https://eprint.iacr.org/2004/027.pdf
*/

library AOSRing
{
	function aos_randkeys(uint256 sk0, uint256 sk1, uint256 sk2, uint256 sk3) public view
	returns (uint256 pk0,uint256 pk1,uint256 pk2,uint256 pk3,uint256 pk4,uint256 pk5, uint256 pk6, uint256 pk7)
	{
		Curve.G1Point memory sk0G = Curve.g1mul(Curve.P1(), sk0 % Curve.N());
		Curve.G1Point memory sk1G = Curve.g1mul(Curve.P1(), sk1 % Curve.N());
		Curve.G1Point memory sk2G = Curve.g1mul(Curve.P1(), sk2 % Curve.N());
		Curve.G1Point memory sk3G = Curve.g1mul(Curve.P1(), sk3 % Curve.N());
		pk0 = sk0G.X; pk1 = sk0G.Y; pk2 = sk1G.X; pk3 = sk1G.Y; pk4 = sk2G.X; pk5 = sk2G.Y; pk6 = sk3G.X; pk7 = sk3G.Y;
	
	}

	function aos_randkeys(uint256[4] memory secret) public view
	returns (uint256[8] memory pubkeys)
	{
		for(uint256 i=0; i < 4;i++){
		uint256 j = i*2;
		Curve.G1Point memory xG = Curve.g1mul(Curve.P1(), secret[i] % Curve.N());
		pubkeys[j] = xG.X;
		pubkeys[j+1] = xG.Y;
		}
	}

	function aos_sign( uint256[8] memory pubkeys, uint256 pair_pk, uint256 pair_sk,uint256[4] memory aos_s, uint256[4] memory aos_e)
		public view
		returns (uint256[8] memory output_pubkeys,uint256[4] memory output_s,uint256 output_e)
	{
		require( pubkeys.length > 0 );
		uint256 myidx;
		
		for(uint256 index=0; index < pubkeys.length; index++){
		if(pubkeys[index] == pair_pk){
			myidx = index;
			} 
		}
		uint256 i = myidx;
		uint256 c;
		for( uint256 n = 0; n < pubkeys.length / 2; n++) {
			uint256 idx = i % (pubkeys.length / 2);
			if(n == 0) c = aos_e[idx];
			else c = aos_e[idx-1];
			uint256 j = idx*2;
			 = Schnorr.schnorr_calc(pubkeys[j],pubkeys[j+1], 1111, aos_s[idx], c);
			i += 1;
		}
		uint256 gap = Curve.submod(aos_e[myidx],aos_e[myidx-1]); 
		aos_s[myidx] = (aos_s[myidx] + ((pair_sk*gap) % Curve.N())) % Curve.N();

		output_pubkeys = pubkeys;
		output_s = aos_s;
		output_e = aos_e[myidx];
	}

	function aos_verify( uint256[4] memory pubkeys, uint256[2] memory aos_s, uint256 aos_e, uint256 message )
		public view
		returns (bool)
	{
		require( pubkeys.length % 2 == 0 );
		require( pubkeys.length > 0 );
		// TODO: verify aos_e
		// TODO: fit message to Curve.N()
		uint256 c = aos_e;
		uint256 nkeys = pubkeys.length / 2;
		for( uint256 i = 0; i < nkeys; i++ ) {
			uint256 j = i * 2;
			c = Schnorr.schnorr_calc(pubkeys[j], pubkeys[j+1], message, aos_s[i], c);
		}
		return c == aos_e;
	}
}