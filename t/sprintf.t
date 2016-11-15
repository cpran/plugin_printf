include ../../plugin_tap/procedures/more.proc
include ../../plugin_printf/procedures/printf.proc

test.fatal = 0
has_system = printf.system
printf.system = 0

@plan: 788

for i to 2
  if printf.system and !has_system
    @skip_all: "No support for system printf (perl)"
  endif

  call @:mytest: "0.33",                   "%.*f",                2, 0.33333333
  call @:mytest: "foo",                    "%.3s",                "foobar"
  call @:mytest: "     00004",             "%10.5d",              4
  call @:mytest: " 42",                    "% d",                 42

  call @:mytest: "-42",                    "% d",                 -42
  call @:mytest: "   42",                  "% 5d",                42
  call @:mytest: "  -42",                  "% 5d",                -42
  call @:mytest: "             42",        "% 15d",               42
  call @:mytest: "            -42",        "% 15d",               -42

  call @:mytest: "+42",                    "%+d",                 42
  call @:mytest: "-42",                    "%+d",                 -42
  call @:mytest: "  +42",                  "%+5d",                42
  call @:mytest: "  -42",                  "%+5d",                -42
  call @:mytest: "            +42",        "%+15d",               42
  call @:mytest: "            -42",        "%+15d",               -42

  call @:mytest: "42",                     "%0d",                 42
  call @:mytest: "-42",                    "%0d",                 -42
  call @:mytest: "00042",                  "%05d",                42
  call @:mytest: "-0042",                  "%05d",                -42
  call @:mytest: "000000000000042",        "%015d",               42
  call @:mytest: "-00000000000042",        "%015d",               -42

  call @:mytest: "42",                     "%-d",                 42
  call @:mytest: "-42",                    "%-d",                 -42
  call @:mytest: "42   ",                  "%-5d",                42
  call @:mytest: "-42  ",                  "%-5d",                -42
  call @:mytest: "42             ",        "%-15d",               42
  call @:mytest: "-42            ",        "%-15d",               -42

  call @:mytest: "42",                     "%-0d",                42
  call @:mytest: "-42",                    "%-0d",                -42
  call @:mytest: "42   ",                  "%-05d",               42
  call @:mytest: "-42  ",                  "%-05d",               -42
  call @:mytest: "42             ",        "%-015d",              42
  call @:mytest: "-42            ",        "%-015d",              -42

  call @:mytest: "42",                     "%0-d",                42
  call @:mytest: "-42",                    "%0-d",                -42
  call @:mytest: "42   ",                  "%0-5d",               42
  call @:mytest: "-42  ",                  "%0-5d",               -42
  call @:mytest: "42             ",        "%0-15d",              42
  call @:mytest: "-42            ",        "%0-15d",              -42

  @todo: 3, "Undefined test"
  call @:mytest: "42",                     "%d",                  42.8952
  call @:mytest: "42",                     "%.2d",                42.8952
  call @:mytest: "42",                     "%.2i",                42.8952

  call @:mytest: "42.90",                  "%.2f",                42.8952
  call @:mytest: "42.90",                  "%.2F",                42.8952
  call @:mytest: "42.8952000000",          "%.10f",               42.8952
  call @:mytest: "42.90",                  "%1.2f",               42.8952
  call @:mytest: " 42.90",                 "%6.2f",               42.8952

  @todo: 1, "Undefined test"
  call @:mytest: "042.90",                 "%06.2f",              42.8952
  if !(printf.system and !has_system)
    call diag:
    ... Technically, this test is undefined according to the      'newline$'
    ... doc. "If a precision is given with a numeric              'newline$'
    ... conversion (d, i, o, u, x, and X), the 0 flag is ignored. 'newline$'
    ... For other conversions, the behavior is undefined."
  endif

  call @:mytest: "+42.90",                 "%+6.2f",              42.8952
  call @:mytest: "42.8952000000",          "%5.10f",              42.8952

  if printf.system and unix
    @skip: 2, "Argument indices not supported"
  endif
  call @:mytest: "Hot Pocket",             "%1$s %2$s",           "Hot", "Pocket"
  call @:mytest: "12.0 Hot Pockets",       "%1$.1f %2$s %3$ss",   12.0, "Hot", "Pocket"

  call @:mytest: " foo",                   "%*s",                 4, "foo"
  call @:mytest: "      3.14",             "%*.*f",               10, 2, 3.14159265
  call @:mytest: "3.14      ",             "%-*.*f",              10, 2, 3.14159265

  @todo: 2, "Failing test"
  call @:mytest: "?",                      "%*s",                 "foo", "bar"
  call @:mytest: "?",                      "%10.*f",              42, "foo"

  call @:mytest: "+hello+",                "+%s+",                "hello"
  call @:mytest: "+10+",                   "+%d+",                10

  @char_test: 3
  call @:mytest: "a",                      "%c",                  "a"
  call @:mytest: " ",                      "%c",                  32
  call @:mytest: "$",                      "%c",                  36

  call @:mytest: "10",                     "%d",                  10

  @char_test: 1
  call @:mytest: "?",                      "%c",                  undefined

  call @:mytest: "+7.894561230000000e+08", "%+#22.15e",           789456123.0
  call @:mytest: "7.894561230000000e+08 ", "%-#22.15e",           789456123.0
  call @:mytest: " 7.894561230000000e+08", "%#22.15e",            789456123.0
  call @:mytest: "7.9e+08",                "%#1.1e",              789456123.0

  @todo: 1, "Tricky formatting in g, but not essential since GHC also fails"
  call @:mytest: "8.e+08",                 "%#1.1g",              789456123.0

  call @:mytest: "    +100",               "%+8lld",              100
  call @:mytest: "+00000100",              "%+.8lld",             100
  call @:mytest: " +00000100",             "%+10.8lld",           100
  call @:mytest: "-00100",                 "%-1.5lld",            -100
  call @:mytest: "  100",                  "%5lld",               100
  call @:mytest: " -100",                  "%5lld",               -100
  call @:mytest: "100  ",                  "%-5lld",              100
  call @:mytest: "-100 ",                  "%-5lld",              -100
  call @:mytest: "00100",                  "%-.5lld",             100
  call @:mytest: "-00100",                 "%-.5lld",             -100
  call @:mytest: "00100   ",               "%-8.5lld",            100
  call @:mytest: "-00100  ",               "%-8.5lld",            -100
  call @:mytest: "00100",                  "%05lld",              100
  call @:mytest: "-0100",                  "%05lld",              -100
  call @:mytest: " 100",                   "% lld",               100
  call @:mytest: "-100",                   "% lld",               -100
  call @:mytest: "  100",                  "% 5lld",              100
  call @:mytest: " -100",                  "% 5lld",              -100
  call @:mytest: " 00100",                 "% .5lld",             100
  call @:mytest: "-00100",                 "% .5lld",             -100
  call @:mytest: "   00100",               "% 8.5lld",            100
  call @:mytest: "  -00100",               "% 8.5lld",            -100
  call @:mytest: "",                       "%.0lld",              0

  @overflow_test: 9
  call @:mytest: " 0x00ffffffffffffff9c",          "%#+21.18llx", -100
  call @:mytest: "0001777777777777777777634",      "%#.25llo",    -100
  call @:mytest: " 01777777777777777777634",       "%#+24.20llo", -100
  call @:mytest: "0X00000FFFFFFFFFFFFFF9C",        "%#+18.21llX", -100
  call @:mytest: "001777777777777777777634",       "%#+20.24llo", -100
  call @:mytest: "   0018446744073709551615",      "%#+25.22llu", -1
  call @:mytest: "   0018446744073709551615",      "%#+25.22llu", -1
  call @:mytest: "     0000018446744073709551615", "%#+30.25llu", -1
  call @:mytest: "  -0000000000000000000001",      "%+#25.22lld", -1

  call @:mytest: "00144   ",               "%#-8.5llo",           100
  call @:mytest: "+00100  ",               "%#-+ 08.5lld",        100
  call @:mytest: "+00100  ",               "%#-+ 08.5lld",        100
  call @:mytest: "0000000000000000000000000000000000000001", "%.40lld",   1
  call @:mytest: " 0000000000000000000000000000000000000001", "% .40lld", 1
  call @:mytest: " 0000000000000000000000000000000000000001", "% .40d",   1

  call @:mytest: " 1",                     "% d",            1
  call @:mytest: "+1",                     "%+ d",           1

  call @:mytest: "0x000000000001",         "%#0.12x",        1
  call @:mytest: "0x0000000001",           "%#012x",         1
  call @:mytest: "0x00000001",             "%#04.8x",        1
  call @:mytest: "0x01    ",               "%#-08.2x",       1
  call @:mytest: "00000001",               "%#08o",          1

  call @:mytest: "f",                      "%.1s",           "foo"
  call @:mytest: "f",                      "%.*s",           1, "foo"
  call @:mytest: "foo  ",                  "%*s",            -5, "foo"
  call @:mytest: "hello",                  "hello",

  @char_test: 1
  call @:mytest: "  a",                    "%3c",            "a"
  call @:mytest: "1234",                   "%3d",            1234

  call @:mytest: "2",                      "%-1d",           2
  call @:mytest: "8.6000",                 "%2.4f",          8.6
  call @:mytest: "1",                      "%.0f",           0.6
  call @:mytest: "8.6000e+00",             "%2.4e",          8.6
  call @:mytest: " 8.6000e+00",            "% 2.4e",         8.6
  call @:mytest: "-8.6000e+00",            "% 2.4e",         -8.6
  call @:mytest: "+8.6000e+00",            "%+2.4e",         8.6
  call @:mytest: "8.6",                    "%2.4g",          8.6

  call @:mytest: "8.6",                    "%g",             8.6
  call @:mytest: "8.6",                    "%1g",            8.6
  call @:mytest: "8.6",                    "%1g",            8.6
  call @:mytest: "8.6",                    "%.2g",           8.6
  call @:mytest: "8",                      "%.2g",           8.04
  call @:mytest: "9",                      "%.1g",           8.6
  call @:mytest: "  9",                    "%3.1g",          8.6

  call @:mytest: "-1",                     "%-i",            -1
  call @:mytest: "1",                      "%-i",            1
  call @:mytest: "+1",                     "%+i",            1
  call @:mytest: "12",                     "%o",             10

  call @:mytest: "%%%%",                   "%s",             "%%%%"

  call @:mytest: "%0",                     "%%0"

  @diag: "Tests from libc"

  call @:mytest: "Hallo heimur",           "Hallo heimur"
  call @:mytest: "Hallo heimur",           "%s",             "Hallo heimur"
  call @:mytest: "1024",                   "%d",             1024
  call @:mytest: "-1024",                  "%d",             -1024
  call @:mytest: "1024",                   "%i",             1024
  call @:mytest: "-1024",                  "%i",             -1024
  call @:mytest: "1024",                   "%u",             1024
  call @:mytest: "4294966272",             "%u",             4294966272
  call @:mytest: "101",                    "%b",             5
  call @:mytest: "777",                    "%o",             511
  call @:mytest: "37777777001",            "%o",             4294966785
  call @:mytest: "1234abcd",               "%x",             305441741
  call @:mytest: "edcb5433",               "%x",             3989525555
  call @:mytest: "1234ABCD",               "%X",             305441741
  call @:mytest: "EDCB5433",               "%X",             3989525555

  @char_test: 1
  call @:mytest: "x",                      "%c",             "x"
  call @:mytest: "%",                      "%%"

  call @:mytest: "Hallo heimur",           "%+s",            "Hallo heimur"
  call @:mytest: "+1024",                  "%+d",            1024
  call @:mytest: "-1024",                  "%+d",            -1024
  call @:mytest: "+1024",                  "%+i",            1024
  call @:mytest: "-1024",                  "%+i",            -1024
  call @:mytest: "1024",                   "%+u",            1024
  call @:mytest: "4294966272",             "%+u",            4294966272
  call @:mytest: "101",                    "%+b",            5
  call @:mytest: "777",                    "%+o",            511
  call @:mytest: "37777777001",            "%+o",            4294966785
  call @:mytest: "1234abcd",               "%+x",            305441741
  call @:mytest: "edcb5433",               "%+x",            3989525555
  call @:mytest: "1234ABCD",               "%+X",            305441741
  call @:mytest: "EDCB5433",               "%+X",            3989525555

  @char_test: 1
  call @:mytest: "x",                      "%+c",            "x"

  call @:mytest: "Hallo heimur",           "% s",            "Hallo heimur"
  call @:mytest: " 1024",                  "% d",            1024
  call @:mytest: "-1024",                  "% d",            -1024
  call @:mytest: " 1024",                  "% i",            1024
  call @:mytest: "-1024",                  "% i",            -1024
  call @:mytest: "1024",                   "% u",            1024
  call @:mytest: "4294966272",             "% u",            4294966272
  call @:mytest: "101",                    "% b",            5
  call @:mytest: "777",                    "% o",            511
  call @:mytest: "37777777001",            "% o",            4294966785
  call @:mytest: "1234abcd",               "% x",            305441741
  call @:mytest: "edcb5433",               "% x",            3989525555
  call @:mytest: "1234ABCD",               "% X",            305441741
  call @:mytest: "EDCB5433",               "% X",            3989525555

  @char_test: 1
  call @:mytest: "x",                      "% c",            "x"

  call @:mytest: "Hallo heimur",           "%+ s",           "Hallo heimur"
  call @:mytest: "+1024",                  "%+ d",           1024
  call @:mytest: "-1024",                  "%+ d",           -1024
  call @:mytest: "+1024",                  "%+ i",           1024
  call @:mytest: "-1024",                  "%+ i",           -1024
  call @:mytest: "1024",                   "%+ u",           1024
  call @:mytest: "4294966272",             "%+ u",           4294966272
  call @:mytest: "101",                    "%+ b",           5
  call @:mytest: "777",                    "%+ o",           511
  call @:mytest: "37777777001",            "%+ o",           4294966785
  call @:mytest: "1234abcd",               "%+ x",           305441741
  call @:mytest: "edcb5433",               "%+ x",           3989525555
  call @:mytest: "1234ABCD",               "%+ X",           305441741
  call @:mytest: "EDCB5433",               "%+ X",           3989525555

  @char_test: 1
  call @:mytest: "x",                      "%+ c",           "x"

  call @:mytest: "0b101",                  "%#b",            5
  call @:mytest: "0777",                   "%#o",            511
  call @:mytest: "037777777001",           "%#o",            4294966785
  call @:mytest: "0x1234abcd",             "%#x",            305441741
  call @:mytest: "0xedcb5433",             "%#x",            3989525555
  call @:mytest: "0X1234ABCD",             "%#X",            305441741
  call @:mytest: "0XEDCB5433",             "%#X",            3989525555
  call @:mytest: "0",                      "%#b",            0
  call @:mytest: "0",                      "%#o",            0
  call @:mytest: "0",                      "%#x",            0
  call @:mytest: "0",                      "%#X",            0

  call @:mytest: "Hallo heimur",           "%1s",            "Hallo heimur"
  call @:mytest: "1024",                   "%1d",            1024
  call @:mytest: "-1024",                  "%1d",            -1024
  call @:mytest: "1024",                   "%1i",            1024
  call @:mytest: "-1024",                  "%1i",            -1024
  call @:mytest: "1024",                   "%1u",            1024
  call @:mytest: "4294966272",             "%1u",            4294966272
  call @:mytest: "101",                    "%1b",            5
  call @:mytest: "777",                    "%1o",            511
  call @:mytest: "37777777001",            "%1o",            4294966785
  call @:mytest: "1234abcd",               "%1x",            305441741
  call @:mytest: "edcb5433",               "%1x",            3989525555
  call @:mytest: "1234ABCD",               "%1X",            305441741
  call @:mytest: "EDCB5433",               "%1X",            3989525555

  @char_test: 1
  call @:mytest: "x",                      "%1c",            "x"

  call @:mytest: "               Hallo",   "%20s",           "Hallo"
  call @:mytest: "                1024",   "%20d",           1024
  call @:mytest: "               -1024",   "%20d",           -1024
  call @:mytest: "                1024",   "%20i",           1024
  call @:mytest: "               -1024",   "%20i",           -1024
  call @:mytest: "                1024",   "%20u",           1024
  call @:mytest: "          4294966272",   "%20u",           4294966272
  call @:mytest: "                 101",   "%20b",           5
  call @:mytest: "                 777",   "%20o",           511
  call @:mytest: "         37777777001",   "%20o",           4294966785
  call @:mytest: "            1234abcd",   "%20x",           305441741
  call @:mytest: "            edcb5433",   "%20x",           3989525555
  call @:mytest: "            1234ABCD",   "%20X",           305441741
  call @:mytest: "            EDCB5433",   "%20X",           3989525555

  @char_test: 1
  call @:mytest: "                   x",   "%20c",           "x"

  call @:mytest: "Hallo               ",   "%-20s",          "Hallo"
  call @:mytest: "1024                ",   "%-20d",          1024
  call @:mytest: "-1024               ",   "%-20d",          -1024
  call @:mytest: "1024                ",   "%-20i",          1024
  call @:mytest: "-1024               ",   "%-20i",          -1024
  call @:mytest: "1024                ",   "%-20u",          1024
  call @:mytest: "4294966272          ",   "%-20u",          4294966272
  call @:mytest: "101                 ",   "%-20b",          5
  call @:mytest: "777                 ",   "%-20o",          511
  call @:mytest: "37777777001         ",   "%-20o",          4294966785
  call @:mytest: "1234abcd            ",   "%-20x",          305441741
  call @:mytest: "edcb5433            ",   "%-20x",          3989525555
  call @:mytest: "1234ABCD            ",   "%-20X",          305441741
  call @:mytest: "EDCB5433            ",   "%-20X",          3989525555

  @char_test: 1
  call @:mytest: "x                   ",   "%-20c",          "x"

  call @:mytest: "00000000000000001024",   "%020d",          1024
  call @:mytest: "-0000000000000001024",   "%020d",          -1024
  call @:mytest: "00000000000000001024",   "%020i",          1024
  call @:mytest: "-0000000000000001024",   "%020i",          -1024
  call @:mytest: "00000000000000001024",   "%020u",          1024
  call @:mytest: "00000000004294966272",   "%020u",          4294966272
  call @:mytest: "00000000000000000101",   "%020b",          5
  call @:mytest: "00000000000000000777",   "%020o",          511
  call @:mytest: "00000000037777777001",   "%020o",          4294966785
  call @:mytest: "0000000000001234abcd",   "%020x",          305441741
  call @:mytest: "000000000000edcb5433",   "%020x",          3989525555
  call @:mytest: "0000000000001234ABCD",   "%020X",          305441741
  call @:mytest: "000000000000EDCB5433",   "%020X",          3989525555

  call @:mytest: "               0b101",   "%#20b",          5
  call @:mytest: "                0777",   "%#20o",          511
  call @:mytest: "        037777777001",   "%#20o",          4294966785
  call @:mytest: "          0x1234abcd",   "%#20x",          305441741
  call @:mytest: "          0xedcb5433",   "%#20x",          3989525555
  call @:mytest: "          0X1234ABCD",   "%#20X",          305441741
  call @:mytest: "          0XEDCB5433",   "%#20X",          3989525555

  call @:mytest: "0b000000000000000101",   "%#020b",         5
  call @:mytest: "00000000000000000777",   "%#020o",         511
  call @:mytest: "00000000037777777001",   "%#020o",         4294966785
  call @:mytest: "0x00000000001234abcd",   "%#020x",         305441741
  call @:mytest: "0x0000000000edcb5433",   "%#020x",         3989525555
  call @:mytest: "0X00000000001234ABCD",   "%#020X",         305441741
  call @:mytest: "0X0000000000EDCB5433",   "%#020X",         3989525555
  call @:mytest: "Hallo               ",   "%0-20s",         "Hallo"
  call @:mytest: "1024                ",   "%0-20d",         1024
  call @:mytest: "-1024               ",   "%0-20d",         -1024
  call @:mytest: "1024                ",   "%0-20i",         1024
  call @:mytest: "-1024               ",   "%0-20i",         -1024
  call @:mytest: "1024                ",   "%0-20u",         1024
  call @:mytest: "4294966272          ",   "%0-20u",         4294966272
  call @:mytest: "101                 ",   "%-020b",         5
  call @:mytest: "777                 ",   "%-020o",         511
  call @:mytest: "37777777001         ",   "%-020o",         4294966785
  call @:mytest: "1234abcd            ",   "%-020x",         305441741
  call @:mytest: "edcb5433            ",   "%-020x",         3989525555
  call @:mytest: "1234ABCD            ",   "%-020X",         305441741
  call @:mytest: "EDCB5433            ",   "%-020X",         3989525555

  @char_test: 1
  call @:mytest: "x                   ",   "%-020c",         "x"

  call @:mytest: "               Hallo",   "%*s",            20, "Hallo"
  call @:mytest: "                1024",   "%*d",            20, 1024
  call @:mytest: "               -1024",   "%*d",            20, -1024
  call @:mytest: "                1024",   "%*i",            20, 1024
  call @:mytest: "               -1024",   "%*i",            20, -1024
  call @:mytest: "                1024",   "%*u",            20, 1024
  call @:mytest: "          4294966272",   "%*u",            20, 4294966272
  call @:mytest: "                 101",   "%*b",            20, 5
  call @:mytest: "                 777",   "%*o",            20, 511
  call @:mytest: "         37777777001",   "%*o",            20, 4294966785
  call @:mytest: "            1234abcd",   "%*x",            20, 305441741
  call @:mytest: "            edcb5433",   "%*x",            20, 3989525555
  call @:mytest: "            1234ABCD",   "%*X",            20, 305441741
  call @:mytest: "            EDCB5433",   "%*X",            20, 3989525555

  @char_test: 1
  call @:mytest: "                   x",   "%*c",            20, "x"

  call @:mytest: "Hallo heimur",           "%.20s",          "Hallo heimur"
  call @:mytest: "00000000000000001024",   "%.20d",          1024
  call @:mytest: "-00000000000000001024",  "%.20d",          -1024
  call @:mytest: "00000000000000001024",   "%.20i",          1024
  call @:mytest: "-00000000000000001024",  "%.20i",          -1024
  call @:mytest: "00000000000000001024",   "%.20u",          1024
  call @:mytest: "00000000004294966272",   "%.20u",          4294966272
  call @:mytest: "00000000000000000101",   "%.20b",          5
  call @:mytest: "00000000000000000777",   "%.20o",          511
  call @:mytest: "00000000037777777001",   "%.20o",          4294966785
  call @:mytest: "0000000000001234abcd",   "%.20x",          305441741
  call @:mytest: "000000000000edcb5433",   "%.20x",          3989525555
  call @:mytest: "0000000000001234ABCD",   "%.20X",          305441741
  call @:mytest: "000000000000EDCB5433",   "%.20X",          3989525555

  call @:mytest: "               Hallo",   "%20.5s",         "Hallo heimur"
  call @:mytest: "               01024",   "%20.5d",         1024
  call @:mytest: "              -01024",   "%20.5d",         -1024
  call @:mytest: "               01024",   "%20.5i",         1024
  call @:mytest: "              -01024",   "%20.5i",         -1024
  call @:mytest: "               01024",   "%20.5u",         1024
  call @:mytest: "          4294966272",   "%20.5u",         4294966272
  call @:mytest: "               00101",   "%20.5b",         5
  call @:mytest: "               00777",   "%20.5o",         511
  call @:mytest: "         37777777001",   "%20.5o",         4294966785
  call @:mytest: "            1234abcd",   "%20.5x",         305441741
  call @:mytest: "          00edcb5433",   "%20.10x",        3989525555
  call @:mytest: "            1234ABCD",   "%20.5X",         305441741
  call @:mytest: "          00EDCB5433",   "%20.10X",        3989525555

  call @:mytest: "               01024",   "%020.5d",        1024
  call @:mytest: "              -01024",   "%020.5d",        -1024
  call @:mytest: "               01024",   "%020.5i",        1024
  call @:mytest: "              -01024",   "%020.5i",        -1024
  call @:mytest: "               01024",   "%020.5u",        1024
  call @:mytest: "          4294966272",   "%020.5u",        4294966272
  call @:mytest: "               00101",   "%020.5b",        5
  call @:mytest: "               00777",   "%020.5o",        511
  call @:mytest: "         37777777001",   "%020.5o",        4294966785
  call @:mytest: "            1234abcd",   "%020.5x",        305441741
  call @:mytest: "          00edcb5433",   "%020.10x",       3989525555
  call @:mytest: "            1234ABCD",   "%020.5X",        305441741
  call @:mytest: "          00EDCB5433",   "%020.10X",       3989525555

  call @:mytest: "",                       "%.0s",           "Hallo heimur"
  call @:mytest: "                    ",   "%20.0s",         "Hallo heimur"
  call @:mytest: "",                       "%.s",            "Hallo heimur"
  call @:mytest: "                    ",   "%20.s",          "Hallo heimur"
  call @:mytest: "                1024",   "%20.0d",         1024
  call @:mytest: "               -1024",   "%20.d",          -1024
  call @:mytest: "                    ",   "%20.d",          0
  call @:mytest: "                1024",   "%20.0i",         1024
  call @:mytest: "               -1024",   "%20.i",          -1024
  call @:mytest: "                    ",   "%20.i",          0
  call @:mytest: "                1024",   "%20.u",          1024
  call @:mytest: "          4294966272",   "%20.0u",         4294966272
  call @:mytest: "                    ",   "%20.u",          0
  call @:mytest: "                 101",   "%20.b",          5
  call @:mytest: "                 777",   "%20.o",          511
  call @:mytest: "         37777777001",   "%20.0o",         4294966785
  call @:mytest: "                    ",   "%20.o",          0
  call @:mytest: "            1234abcd",   "%20.x",          305441741
  call @:mytest: "            edcb5433",   "%20.0x",         3989525555
  call @:mytest: "                    ",   "%20.x",          0
  call @:mytest: "            1234ABCD",   "%20.X",          305441741
  call @:mytest: "            EDCB5433",   "%20.0X",         3989525555
  call @:mytest: "                    ",   "%20.X",          0

  call @:mytest: "Hallo               ",   "% -0+*.*s",      20, 5, "Hallo heimur"
  call @:mytest: "+01024              ",   "% -0+*.*d",      20, 5, 1024
  call @:mytest: "-01024              ",   "% -0+*.*d",      20, 5, -1024
  call @:mytest: "+01024              ",   "% -0+*.*i",      20, 5, 1024
  call @:mytest: "-01024              ",   "% 0-+*.*i",      20, 5, -1024
  call @:mytest: "01024               ",   "% 0-+*.*u",      20, 5, 1024
  call @:mytest: "4294966272          ",   "% 0-+*.*u",      20, 5, 4294966272
  call @:mytest: "00101               ",   "%+ -0*.*b",      20, 5, 5
  call @:mytest: "00777               ",   "%+ -0*.*o",      20, 5, 511
  call @:mytest: "37777777001         ",   "%+ -0*.*o",      20, 5, 4294966785
  call @:mytest: "1234abcd            ",   "%+ -0*.*x",      20, 5, 305441741
  call @:mytest: "00edcb5433          ",   "%+ -0*.*x",      20, 10, 3989525555
  call @:mytest: "1234ABCD            ",   "% -+0*.*X",      20, 5, 305441741
  call @:mytest: "00EDCB5433          ",   "% -+0*.*X",      20, 10, 3989525555

  printf.system += 1

endfor

@done_testing()

procedure mytest ()
  .expected$ = .argv$[1]
  .format$ = .argv$[2]
  .msg$ = replace$(.format$, "#", "\#", 0)

  if plan.skip != undefined and !plan.skip
    .args$ = extractLine$(.args$, ",")
    call @:sprintf: 'mytest.args$'
  else
    sprintf.return$ = ""
  endif

  @is$: sprintf.return$, .expected$,
    ... if printf.system then "(system) " else "(PP) " fi + .msg$
endproc

procedure overflow_test: .num
  if !printf.system
    @skip: .num, "PP: Numeric over/underflow not supported"
  endif
endproc

procedure binary_test: .num
  if printf.system and unix
    @skip: .num, "PP: Binary tests not supported with system printf in Linux"
  endif
endproc

procedure char_test: .num
  if !printf.system or unix
    @skip: .num, "PP: Character tests not applicable"
  endif
endproc
