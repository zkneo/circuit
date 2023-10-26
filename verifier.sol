// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 82879643093427437835521839145869959311460440131371940978054540049071790181082488217327694954206702698741888736967;
    uint256 constant alphay  = 2994584791185995847291823247109043341337516050004538689034436046536996656374310464924768186084691359915754991015326;
    uint256 constant betax1  = 3546830986413182605236114145076160062271424342398004767034790160663538299679279353858326792366247133694619544955308;
    uint256 constant betax2  = 3863200909709723450251811204982926590268440689463542178759551980594023147635176697436293717038451985374478071649364;
    uint256 constant betay1  = 1863382547038205709483029105998242748236201522853943705306245278815009957005317088014386324342408845013243040782600;
    uint256 constant betay2  = 687587355881035409185436584560241294322220521121772236211560136101928577292552012599416589561933391794733289639287;
    uint256 constant gammax1 = 3059144344244213709971259814753781636986470325476647558659373206291635324768958432433509563104347017837885763365758;
    uint256 constant gammax2 = 352701069587466618187139116011060144890029952792775240219908644239793785735715026873347600343865175952761926303160;
    uint256 constant gammay1 = 927553665492332455747201965776037880757740193453592970025027978793976877002675564980949289727957565575433344219582;
    uint256 constant gammay2 = 1985150602287291935568054521177171638300868978215655730859378665066344726373823718423869104263333984641494340347905;
    uint256 constant deltax1 = 413075256138291794649640018013801146749385116792939141813015852217603724772866427647549255860602572882154144081639;
    uint256 constant deltax2 = 2418424979259670653683223232030436436248517664853791894338975346530063981794048249650152995905545988866327060920881;
    uint256 constant deltay1 = 1795564638904040188383738569443557389610841057297376921781847606689534772302064682586408726674325977627716491786526;
    uint256 constant deltay2 = 199790345085509099603154525332514682614754623855294071516180833696381501701072255443069957158539649915659301989757;

    
    uint256 constant IC0x = 354799492121255153174187180151332557669808140367680494608158160105999105828830195943214550314497513496109384908767;
    uint256 constant IC0y = 1350887899994993167157032975857193376434503042175108159016054195630196933326858395210439084062191628200912844414282;
    
    uint256 constant IC1x = 2997398522787486908957371725636137834577879096386836139874326043224850590073248413858474699224858213305674270873547;
    uint256 constant IC1y = 2078090060199988269447988743730343743598010411928263202186367168163553510054874805632824011770304042987045414571889;
    
    uint256 constant IC2x = 3481500889715949937920891664850234168552345226568578845770624364881521601074216406838808335375693769887093865148721;
    uint256 constant IC2y = 1720258193327617401327128236305324033072767741154996143273260844181144195348488798281889564249030192374217644833500;
    
    uint256 constant IC3x = 1065726661732437803256053258617081256292156040967654763086221613079472959198623910371312887799681396600957055183207;
    uint256 constant IC3y = 248226801500941191196615401001867654889717992762493885536889455488439559218476479155323864951204214667008266390257;
    
    uint256 constant IC4x = 1565191720061827706101749446502489471868800421586447072181956599498064942796283089983843389574590245883243473250824;
    uint256 constant IC4y = 487474444617926404659992388397370167698873877810394448940371227223264473498417606825455770762078755223029357137276;
    
    uint256 constant IC5x = 224740006381595956635000253654877798282130586437544816521141699856967041081238461993329916274656525793440247825430;
    uint256 constant IC5y = 2578534050655053334725559052410890914765894677836689565590857727630811634946885402560046542218084075855505273056747;
    
    uint256 constant IC6x = 1898318026493394922663893601585751741570807324219723077488919014090682201488776072359862204351035073869353481913234;
    uint256 constant IC6y = 348009879358606781791642953501421019247101636971673841298089174194707967148514252641176171540615530455201528091072;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[6] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, q)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals, 0)))
            
            checkField(calldataload(add(_pubSignals, 32)))
            
            checkField(calldataload(add(_pubSignals, 64)))
            
            checkField(calldataload(add(_pubSignals, 96)))
            
            checkField(calldataload(add(_pubSignals, 128)))
            
            checkField(calldataload(add(_pubSignals, 160)))
            
            checkField(calldataload(add(_pubSignals, 192)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
