// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Curve.sol";

// https://en.wikipedia.org/wiki/Proof_of_knowledge#Schnorr_protocol
library Schnorr
{
	function schnorr_multisign( uint256 secret, uint256 message, uint256[] memory pubkeys)
	    public view
	    returns (uint256 agg_pubkey1,uint256 agg_pubkey2, uint256 out_s, uint256 out_e)
	{
		Curve.G1Point memory xG = Curve.g1mul(Curve.P1(), secret % Curve.N());
		uint256 nkeys = pubkeys.length / 2;
		for(uint256 i = 0; i < nkeys; i++){
			uint256 j = i * 2;
			xG = Curve.g1add(xG, Curve.G1Point(pubkeys[j],pubkeys[j+1]));
		}
		agg_pubkey1 = xG.X;
		agg_pubkey2 = xG.Y;
		uint256 k = uint256(keccak256(abi.encodePacked(message, secret))) % Curve.N();
		Curve.G1Point memory kG = Curve.g1mul(Curve.P1(), k);
		out_e = uint256(keccak256(abi.encodePacked(agg_pubkey1, agg_pubkey2, kG.X, kG.Y, message)));
		out_s = Curve.submod(k, mulmod(secret, out_e, Curve.N()));
	}
	
    // Costs ~85000 gas, 2x ecmul, + mulmod, addmod, hash etc. overheads
	function schnorr_sign( uint256 secret, uint256 message )
	    public view
	    returns (uint256 out_pubkey1,uint256 out_pubkey2, uint256 out_s, uint256 out_e)
	{
		Curve.G1Point memory xG = Curve.g1mul(Curve.P1(), secret % Curve.N());
		out_pubkey1 = xG.X;
		out_pubkey2 = xG.Y;
		uint256 k = uint256(keccak256(abi.encodePacked(message, secret))) % Curve.N();
		Curve.G1Point memory kG = Curve.g1mul(Curve.P1(), k);
		out_e = uint256(keccak256(abi.encodePacked(out_pubkey1, out_pubkey2, kG.X, kG.Y, message)));
		out_s = Curve.submod(k, mulmod(secret, out_e, Curve.N()));
	}

	function adaptor_sign( uint256 secret, uint256 message )
	    public view
	    returns (uint256 out_pubkey1,uint256 out_pubkey2, uint256 out_s, uint256 out_e)
	{
		Curve.G1Point memory xG = Curve.g1mul(Curve.P1(), secret % Curve.N());
		out_pubkey1 = xG.X;
		out_pubkey2 = xG.Y;
		uint256 k = uint256(keccak256(abi.encodePacked(message, secret))) % Curve.N();
		Curve.G1Point memory kG = Curve.g1mul(Curve.P1(), k);
		uint256 t = 100; // random value
		Curve.G1Point memory tG = Curve.g1mul(Curve.P1(), t);
		Curve.G1Point memory ktG = Curve.g1add(kG, tG);
		out_e = uint256(keccak256(abi.encodePacked(out_pubkey1, out_pubkey2, ktG.X, ktG.Y, message)));
		out_s = Curve.submod(k, mulmod(secret, out_e, Curve.N()));
	}

	// Costs ~85000 gas, 2x ecmul, 1x ecadd, + small overheads
	function schnorr_calc( uint256 pubkey1,uint256 pubkey2, uint256 message, uint256 s, uint256 e )
	    public view
	    returns (uint256)
	{
	    Curve.G1Point memory sG = Curve.g1mul(Curve.P1(), s % Curve.N());
	    Curve.G1Point memory xG = Curve.G1Point(pubkey1, pubkey2);
	    Curve.G1Point memory kG = Curve.g1add(sG, Curve.g1mul(xG, e));
	    return uint256(keccak256(abi.encodePacked(pubkey1, pubkey2, kG.X, kG.Y, message)));
	}
	
	function schnorr_aos_calc( uint256[2] memory pubkeys, uint256 message, uint256 s, uint256 e )
	    public view
	    returns (uint256)
	{
	    Curve.G1Point memory sG = Curve.g1mul(Curve.P1(), s % Curve.N());
	    Curve.G1Point memory xG = Curve.G1Point(pubkeys[0], pubkeys[1]);
	    Curve.G1Point memory kG = Curve.g1add(sG, Curve.g1mul(xG, e));
	    return uint256(keccak256(abi.encodePacked(pubkeys[0], pubkeys[1], kG.X, kG.Y, message)));
	}

	function schnorr_verify( uint256 pubkey1,uint256 pubkey2, uint256 message, uint256 s, uint256 e )
	    public view
	    returns (bool)
	{
	    return e == schnorr_calc(pubkey1,pubkey2, message, s, e);
	}
}