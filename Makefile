#################################general setup#######################################
1_init:
	npx snarkjs powersoftau new bls12-381 14 pot14_0000.ptau -v
2_contribute:
	npx snarkjs powersoftau contribute pot14_0000.ptau pot14_0001.ptau --name="First contribution" -v
5_verify_protocol:
	npx snarkjs powersoftau verify pot14_0001.ptau
6_end_phase_1:
	npx snarkjs powersoftau beacon pot14_0001.ptau pot14_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon"
7_phase2_prepare:
	npx snarkjs powersoftau prepare phase2 pot14_beacon.ptau pot14_final.ptau -v
8_phase2_verify:
	npx snarkjs powersoftau verify pot14_final.ptau

#################################circuit and input####################################
10_compile:
	npx circom circuit.circom --r1cs --wasm --sym -p bls12381
11_info:
	npx snarkjs r1cs info circuit.r1cs
12_print:
	npx snarkjs r1cs print circuit.r1cs circuit.sym
13_r1cs_tojson:
	npx snarkjs r1cs export json circuit.r1cs circuit.r1cs.json
14_witness:
	npx snarkjs wtns calculate circuit.wasm input.json witness.wtns && npx snarkjs wtns check circuit.r1cs witness.wtns

#################################circuit setup#######################################
15_setup:
	npx snarkjs groth16 setup circuit.r1cs pot14_final.ptau circuit_0000.zkey
16_contribute:
	npx snarkjs zkey contribute circuit_0000.zkey circuit_0001.zkey --name="1st Contributor Name" -v
19_verify:
	npx snarkjs zkey verify circuit.r1cs pot14_final.ptau circuit_0001.zkey
20_apply_random_beacon:
	npx snarkjs zkey beacon circuit_0001.zkey circuit_final.zkey 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"
21_verify:
	npx snarkjs zkey verify circuit.r1cs pot14_final.ptau circuit_final.zkey
22_verification_key:
	npx snarkjs zkey export verificationkey circuit_final.zkey verification_key.json

#############################generate and verify######################################
23_generate:
	npx snarkjs groth16 prove circuit_final.zkey witness.wtns proof.json public.json
24_verify:
	npx snarkjs groth16 verify verification_key.json public.json proof.json


###########################contract and calldata######################################
25_generate_smartcontract:
	npx snarkjs zkey export solidityverifier circuit_final.zkey verifier.sol
26_simulate_call:
	npx snarkjs zkey export soliditycalldata public.json proof.json

