4-5 БАЛЛОВ

Проведя исследование, я вычислил, что ОДЗ для данной задачи: -113<=x<=113, 
так как при больших или меньших числах, будет происходит переполнения double и вычисления 
с помощью степенного ряда будут давать бесконечность.

1. Создаем файл float6.c 
В нем написан код с использованием локальных переменных, передачей параметров, поэтому откомментированный
ассемблер будет сразу на 5 баллов.

2. gcc -S -O0 float6.c -o float6.s
Будет создан ассемблерный файл float6.s, откомпилированный без оптимизирующих и отладочных опций 
из-за использования ключа -O0

Комментарии по ассемблеру


3. gcc -S -O0 -Wall  -fno-asynchronous-unwind-tables -fcf-protection=none float6.c -o float6_opt.s
данная команда уберет все макросы .cfi, которые генерируют отладочную информацию.
В этот файл внесем все комментарии по ассемблеру.


cat float6_opt.s | awk '/^\t\./ { print $1 }' | sort | uniq > asm_macros.md
Данная команда создаст файл asm_macros.md на основе String_optimized.s, в котором 
будут записаны все используемые макросы. Если выполним то же самое для  файла String_with_no_description.s, то там будут 
макросы .cfi

4. gcc -O0 float6_opt.s -o float6_opt.out 
данная команда создаст исполняемый файл float6_opt.out из ассемблерного файла float6_opt.s
5. gcc -O0 float6.s -o float6.out 
данная команда создаст исполняемый файл float6.out из ассемблерного файла float6.s


6. Чтобы запустить файл и протестировать, нужно переместиться в папку с файлом и выполнить команду
./float6.out или ./float6_opt.out. Выполним обе команды, чтобы сравнить результаты тестов.

тесты:
1)  1
Вывод: 1.543080
2) 4
Вывод: 27.308016
3) 113
Вывод: 5942804258089824955530100282386907391342919286784.000000
4) -1
Вывод: 1.543080
5) -4
Вывод: 27.308016
6) -113
Вывод: 5942804258089824955530100282386907391342919286784.000000
7) 0 
Вывод: 1.000000

Вывод: обе программы дают одинаковый и корректный результат на тестах. 
Результаты всех программ на тестах 1-7 приведены на скриншоте float6.png и float6_opt.png
Все проведенные модификации сохраняют корректность работы программы.



6 БАЛЛОВ

1. Создадим файл float_regs.s - в нем будут те же комментарии, что и в ассемблере без рефакторинга с регистрами
Строка будет содержать старый комментарий, но вместо позиции на стеке будет либо регистр для работы с вещественными числами (xmm... 0-10),
либо знакомые из предыдущих заданий r8-r10

2. Канарейка оставлена на стеке, а команда leaq всего лишь высчитывает адрес, а не обращается напрямую к памяти, поэтому
заменять ее на регистры не имеет смысла, так как повышения эффективности тут не получить.

3. также создан файл float_regs.out, который показывает корректную работу программы после внесения всех изменений на тестах 1-7.
Результат тестов показан на скриншоте float_regs.png

