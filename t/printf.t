include ../../plugin_tap/procedures/more.proc
include ../../plugin_printf/procedures/printf.proc

test.fatal = 0

@no_plan()

procedure mytest: .expected$, .format$
  call @:sprintf: mytest.format$
  @is$: sprintf.return$, .expected$, .format$
endproc

procedure mytest_n: .expected$, .format$, .a
  call @:sprintf: mytest_n.format$, mytest_n.a
  @is$: sprintf.return$, .expected$, .format$
endproc

procedure mytest_nn: .expected$, .format$, .a, .b
  call @:sprintf: mytest_nn.format$, mytest_nn.a, mytest_nn.b
  @is$: sprintf.return$, .expected$, .format$
endproc

procedure mytest_nnn: .expected$, .format$, .a, .b, .c
  call @:sprintf: mytest_nnn.format$, mytest_nnn.a, mytest_nnn.b, mytest_nnn.c
  @is$: sprintf.return$, .expected$, .format$
endproc

procedure mytest_s: .expected$, .format$, .a$
  call @:sprintf: mytest_s.format$, mytest_s.a$
  @is$: sprintf.return$, .expected$, .format$
endproc

procedure mytest_ss: .expected$, .format$, .a$, .b$
  call @:sprintf: mytest_ss.format$, mytest_ss.a$, mytest_ss.b$
  @is$: sprintf.return$, .expected$, .format$
endproc

procedure mytest_ns: .expected$, .format$, .a, .a$
  call @:sprintf: mytest_ns.format$, mytest_ns.a, mytest_ns.a$
  @is$: sprintf.return$, .expected$, .format$
endproc

procedure mytest_nss: .expected$, .format$, .a, .a$, .b$
  call @:sprintf: mytest_nss.format$, mytest_nss.a, mytest_nss.a$, mytest_nss.b$
  @is$: sprintf.return$, .expected$, .format$
endproc

@diag: "Regression tests from GHC"

@mytest_nn: "0.33",                  "%.*f",              2, 0.33333333
@mytest_s:  "foo",                   "%.3s",              "foobar"
@mytest_n:  "     00004",            "%10.5d",            4

@diag: "Tests from NPM"

@mytest_n: " 42",                    "% d",               42

@mytest_n: "-42",                    "% d",               -42
@mytest_n: "   42",                  "% 5d",              42
@mytest_n: "  -42",                  "% 5d",              -42
@mytest_n: "             42",        "% 15d",             42
@mytest_n: "            -42",        "% 15d",             -42

@mytest_n: "+42",                    "%+d",               42
@mytest_n: "-42",                    "%+d",               -42
@mytest_n: "  +42",                  "%+5d",              42
@mytest_n: "  -42",                  "%+5d",              -42
@mytest_n: "            +42",        "%+15d",             42
@mytest_n: "            -42",        "%+15d",             -42

@mytest_n: "42",                     "%0d",               42
@mytest_n: "-42",                    "%0d",               -42
@mytest_n: "00042",                  "%05d",              42
@mytest_n: "-0042",                  "%05d",              -42
@mytest_n: "000000000000042",        "%015d",             42
@mytest_n: "-00000000000042",        "%015d",             -42

@mytest_n: "42",                     "%-d",               42
@mytest_n: "-42",                    "%-d",               -42
@mytest_n: "42   ",                  "%-5d",              42
@mytest_n: "-42  ",                  "%-5d",              -42
@mytest_n: "42             ",        "%-15d",             42
@mytest_n: "-42            ",        "%-15d",             -42
@mytest_n: "42",                     "%-0d",              42
@mytest_n: "-42",                    "%-0d",              -42
@mytest_n: "42   ",                  "%-05d",             42
@mytest_n: "-42  ",                  "%-05d",             -42
@mytest_n: "42             ",        "%-015d",            42
@mytest_n: "-42            ",        "%-015d",            -42
@mytest_n: "42",                     "%0-d",              42
@mytest_n: "-42",                    "%0-d",              -42
@mytest_n: "42   ",                  "%0-5d",             42
@mytest_n: "-42  ",                  "%0-5d",             -42
@mytest_n: "42             ",        "%0-15d",            42
@mytest_n: "-42            ",        "%0-15d",            -42

@todo: 3, "Undefined test"
@mytest_n: "42",                     "%d",                42.8952
@mytest_n: "42",                     "%.2d",              42.8952
@mytest_n: "42",                     "%.2i",              42.8952

@mytest_n: "42.90",                  "%.2f",              42.8952
@mytest_n: "42.90",                  "%.2F",              42.8952
@mytest_n: "42.8952000000",          "%.10f",             42.8952
@mytest_n: "42.90",                  "%1.2f",             42.8952
@mytest_n: " 42.90",                 "%6.2f",             42.8952

@todo: 1, "Undefined test"
@mytest_n: "042.90",                "%06.2f",            42.8952
call diag:
... Technically, this test is undefined according to the      'newline$'
... doc. "If a precision is given with a numeric              'newline$'
... conversion (d, i, o, u, x, and X), the 0 flag is ignored. 'newline$'
... For other conversions, the behavior is undefined."

@mytest_n: "+42.90",                "%+6.2f",            42.8952
@mytest_n: "42.8952000000",         "%5.10f",            42.8952

@todo: 2, "Failing test"
@mytest_n: "?",                     "%c",                -100
@mytest_n: "?",                     "%c",                2097152

if printf.system
  @skip: 2, "Argument indices not supported"
endif
@mytest_ss: "Hot Pocket",            "%1$s %2$s",         "Hot", "Pocket"
@mytest_nss: "12.0 Hot Pockets",     "%1$.1f %2$s %3$ss", 12.0, "Hot", "Pocket"

# !H 58 ?                       "%2$*s"         "Hot Pocket"
# # haskell correctly reports an error
# !H 59 "%(foo"                 "%(foo"
#
#   60 " foo"                  "%*s"           4 "foo"
#   61 "      3.14"            "%*.*f"         10 2 3.14159265
# # This test is undefined. See test 48 above.
# # 62 "0000003.14"            "%0*.*f"        10 2 3.14159265

@mytest_nnn: "3.14      ",         "%-*.*f",       10, 2, 3.14159265

@todo: 2, "Failing test"
@mytest_ss: "?",                    "%*s",          "foo", "bar"
@mytest_ns: "?",                    "%10.*f",       42, "foo"

@mytest_s: "+hello+",               "+%s+",          "hello"
@mytest_n: "+10+",                  "+%d+",          10

@skip: 3, "Character tests not applicable"
@mytest_s: "a",                    "%c",            "a"
@mytest_n: " ",                    "%c",            32
@mytest_n: "$",                    "%c",            36

@mytest_n: "10",                   "%d",            10

@todo: 1, "Failing test"
@mytest_n: "?",                    "%s%s",          42

@skip: 1, "Character tests not applicable"
@mytest_n: "?",                    "%c", undefined

# # glibc printf fails this test, returns ""
# # Haskell fails this test claiming that "argument list ended
# # prematurely", which is not so reasonable.
# !CH 74 "%10"                   "%10"           42
# # glibc printf fails this test, returns "10 "
# # Haskell correctly throws an error
# !CH 75 "10 %"                  "%d %"          10
#
# # Tests from MSVCRT
# # Haskell fails these tests due to different floating formatting
# !H 76 "+7.894561230000000e+08"        "%+#22.15e"     789456123.0
# !H 77 "7.894561230000000e+08 "        "%-#22.15e"     789456123.0
# !H 78 " 7.894561230000000e+08"        "%#22.15e"      789456123.0
# !H 79 "8.e+08"                        "%#1.1g"        789456123.0
#
# # The arg constant here is not legal C.
# # 80 "-8589934591"                   "%lld"         18446744065119617025LL
#   81 "    +100"                      "%+8lld"       100LL
#   82 "+00000100"                     "%+.8lld"      100LL
#   83 " +00000100"                    "%+10.8lld"    100LL
# # Haskell correctly reports an error here
# !H 84 "%_1lld"                        "%_1lld"       100
@mytest_n: "-00100",                        "%-1.5lld",     -100
@mytest_n: "  100",                         "%5lld",        100
@mytest_n: " -100",                         "%5lld",        -100
@mytest_n: "100  ",                         "%-5lld",       100
@mytest_n: "-100 ",                         "%-5lld",       -100
@mytest_n: "00100",                         "%-.5lld",      100
@mytest_n: "-00100",                        "%-.5lld",      -100
@mytest_n: "00100   ",                      "%-8.5lld",     100
@mytest_n: "-00100  ",                      "%-8.5lld",     -100
@mytest_n: "00100",                         "%05lld",       100
@mytest_n: "-0100",                         "%05lld",       -100
@mytest_n: " 100",                          "% lld",        100
@mytest_n: "-100",                          "% lld",        -100
@mytest_n: "  100",                         "% 5lld",       100
@mytest_n: " -100",                         "% 5lld",       -100
@mytest_n: " 00100",                        "% .5lld",      100
@mytest_n: "-00100",                        "% .5lld",      -100
@mytest_n: "   00100",                      "% 8.5lld",     100
@mytest_n: "  -00100",                      "% 8.5lld",     -100
@mytest_n: "",                              "%.0lld",       0
@mytest_n: " 0x00ffffffffffffff9c",         "%#+21.18llx",  -100
@mytest_n: "0001777777777777777777634",     "%#.25llo",     -100
@mytest_n: " 01777777777777777777634",      "%#+24.20llo",  -100
@mytest_n: "0X00000FFFFFFFFFFFFFF9C",       "%#+18.21llX",  -100
@mytest_n: "001777777777777777777634",      "%#+20.24llo",  -100
@mytest_n: "   0018446744073709551615",     "%#+25.22llu",  -1
@mytest_n: "   0018446744073709551615",     "%#+25.22llu",  -1
@mytest_n: "     0000018446744073709551615", "%#+30.25llu", -1
@mytest_n: "  -0000000000000000000001",     "%+#25.22lld",  -1
@mytest_n: "00144   ",                      "%#-8.5llo",    100
@mytest_n: "+00100  ",                      "%#-+ 08.5lld", 100
@mytest_n: "+00100  ",                      "%#-+ 08.5lld", 100
@mytest_n: "0000000000000000000000000000000000000001", "%.40lld", 1
@mytest_n: " 0000000000000000000000000000000000000001", "% .40lld", 1
@mytest_n: " 0000000000000000000000000000000000000001", "% .40d", 1
# #See above.
# #120 "-8589934591"                   "%lld"          18446744065119617025LL
# # libc fails this, with "" and return code -1 (!)
# # Haskell correctly reports an error here
# !CH 121 "%I"                            "%I"            1
# # The next two tests are locale-specific and should not be used
# #122 "1"                             "%I0d"          1
# #123 "                               1" "%I32d"         1
# # libc fails this, with "%D"
# # Haskell correctly throws an error
# !CH 124 "%llD"                          "%llD"          -1LL
#
#  125 " 1"                            "% d"           1
#  126 "+1"                            "%+ d"          1
# # These tests are undefined.
# #127 "0001"                          "%04c"          '1'
# #128 "1   "                          "%-04c"         '1'
#  129 "0x0000000001"                  "%#012x"        1
#  130 "0x00000001"                    "%#04.8x"       1
#  131 "0x01    "                      "%#-08.2x"      1
#  132 "00000001"                      "%#08o"         1
# # Haskell has no pointers
# !H 133 "0x39"                          "%p"            57VLL
# # These tests are undefined.
# #134 "  0X0000000000000039"          "%#020p"        57VLL
# #135 "0000000000000039"              "%Fp"           57VLL
# #136 "0X0000000000000039  "          "%#-020p"       57VLL
# # Haskell has no pointers
# !H 137 "0x39"                          "%p"            57V
# # These tests are undefined.
# #138 "  0X00000039"                  "%#012p"        57V
# #139 "00000039"                      "%Fp"           57V
# #140 "0X00000039  "                  "%#-012p"       57V
# #141 "0foo"                          "%04s"          "foo"
#  142 "f"                             "%.1s"          "foo"
#  143 "f"                             "%.*s"          1 "foo"
#  144 "foo  "                         "%*s"           -5 "foo"
#  145 "hello"                         "hello"
# # This test is undefined.
# #146 "not wide"                      "%Ls"           "not wide"
# # Haskell correctly throws an error
# !H 147 "%b"                            "%b"
#  148 "  a"                           "%3c"           'a'
#  149 "1234"                          "%3d"           1234
# # libc fails this, with "" and return code -1
# # Haskell correctly throws an error
# !CH 150 "%3h"                           "%3h"
# # libc fails this, with a big mess worth sorting out later.
# # Note that the given result is clearly wrong.
# #151 "jkmqrtvyz"                     "%j%k%m%q%r%t%v%y%z"
#  152 "2"                             "%-1d"          2
#  153 "8.6000"                        "%2.4f"         8.6
# # Haskell fails these because of different floating point formatting
# !H 154 "0.600000"                      "%0f"           0.6
#  155 "1"                             "%.0f"          0.6
# !H 156 "8.6000e+00"                    "%2.4e"         8.6
# !H 157 " 8.6000e+00"                   "% 2.4e"        8.6
# # This test is undefined, due to a weird codicil in the
# # manpage re zero flag plus precision for non-integral formats.
# # 158 " 0008.6000e+00"                 "% 014.4e"      8.6
# !H 159 "-8.6000e+00"                   "% 2.4e"        -8.6
# !H 160 "+8.6000e+00"                   "%+2.4e"        8.6
# !H 161 "8.6"                           "%2.4g"         8.6
#  162 "-1"                            "%-i"           -1
#  163 "1"                             "%-i"           1
#  164 "+1"                            "%+i"           1
#  165 "12"                            "%o"            10
# # libc fails these, returning "(nil)", which is not
# # allowed by the spec. Haskell has no pointer type.
# !CH 166 "0x0"                           "%p"            0VLL
# !CH 167 "0x0"                           "%p"            0V
# # This test is undefined.
# #168 "(null)"                        "%s"            0
#  169 "%%%%"                          "%s"            "%%%%"
#  170 "4294967295"                    "%u"            -1
# # Haskell correctly throws an error on these
# !H 171 "%w"                            "%w"            -1
# # libc fails these, with "" and return -1
# !CH 172 "%h"                            "%h"            -1
# !CH 173 "%z"                            "%z"            -1
# !CH 174 "%j"                            "%j"            -1
# # This test is undefined.
# #175 ""                              "%F"            -1
# # Haskell correctly throws an error on this.
# !H 176 "%H"                          "%H"            -1
#  177 "%0"                            "%%0"
# # Haskell returns "12345"; this is arguably correct for Haskell.
# !H 178 "2345"                          "%hx"           74565
#  179 "61"                            "%hhx"          'a'
# # This test seems hopeless: I don't understand it.
# #180 "2345"                          "%hhx"          74565
#

@diag: "Tests from libc"

@mytest:   "Hallo heimur",          "Hallo heimur"
@mytest_s: "Hallo heimur",          "%s",            "Hallo heimur"
@mytest_n: "1024",                  "%d",            1024
@mytest_n: "-1024",                 "%d",            -1024
@mytest_n: "1024",                  "%i",            1024
@mytest_n: "-1024",                 "%i",            -1024
@mytest_n: "1024",                  "%u",            1024
@mytest_n: "4294966272",            "%u",            4294966272
@mytest_n: "777",                   "%o",            511
@mytest_n: "37777777001",           "%o",            4294966785
@mytest_n: "1234abcd",              "%x",            305441741
@mytest_n: "edcb5433",              "%x",            3989525555
@mytest_n: "1234ABCD",              "%X",            305441741
@mytest_n: "EDCB5433",              "%X",            3989525555

@skip: 1, "Character tests not applicable"
@mytest_s: "x",                     "%c",            "x"
@mytest:   "%",                     "%%"

@mytest_s: "Hallo heimur",          "%+s",           "Hallo heimur"
@mytest_n: "+1024",                 "%+d",           1024
@mytest_n: "-1024",                 "%+d",           -1024
@mytest_n: "+1024",                 "%+i",           1024
@mytest_n: "-1024",                 "%+i",           -1024
@mytest_n: "1024",                  "%+u",           1024
@mytest_n: "4294966272",            "%+u",           4294966272
@mytest_n: "777",                   "%+o",           511
@mytest_n: "37777777001",           "%+o",           4294966785
@mytest_n: "1234abcd",              "%+x",           305441741
@mytest_n: "edcb5433",              "%+x",           3989525555
@mytest_n: "1234ABCD",              "%+X",           305441741
@mytest_n: "EDCB5433",              "%+X",           3989525555

@skip: 1, "Character tests not applicable"
@mytest_s: "x",                     "%+c",           "x"

@mytest_s: "Hallo heimur",          "% s",           "Hallo heimur"
@mytest_n: " 1024",                 "% d",           1024
@mytest_n: "-1024",                 "% d",           -1024
@mytest_n: " 1024",                 "% i",           1024
@mytest_n: "-1024",                 "% i",           -1024
@mytest_n: "1024",                  "% u",           1024
@mytest_n: "4294966272",            "% u",           4294966272
@mytest_n: "777",                   "% o",           511
@mytest_n: "37777777001",           "% o",           4294966785
@mytest_n: "1234abcd",              "% x",           305441741
@mytest_n: "edcb5433",              "% x",           3989525555
@mytest_n: "1234ABCD",              "% X",           305441741
@mytest_n: "EDCB5433",              "% X",           3989525555

@skip: 1, "Character tests not applicable"
@mytest_s: "x",                     "% c",           "x"

@mytest_s: "Hallo heimur",          "%+ s",          "Hallo heimur"
@mytest_n: "+1024",                 "%+ d",          1024
@mytest_n: "-1024",                 "%+ d",          -1024
@mytest_n: "+1024",                 "%+ i",          1024
@mytest_n: "-1024",                 "%+ i",          -1024
@mytest_n: "1024",                  "%+ u",          1024
@mytest_n: "4294966272",            "%+ u",          4294966272
@mytest_n: "777",                   "%+ o",          511
@mytest_n: "37777777001",           "%+ o",          4294966785
@mytest_n: "1234abcd",              "%+ x",          305441741
@mytest_n: "edcb5433",              "%+ x",          3989525555
@mytest_n: "1234ABCD",              "%+ X",          305441741
@mytest_n: "EDCB5433",              "%+ X",          3989525555

@skip: 1, "Character tests not applicable"
@mytest_s: "x",                     "%+ c",          "x"

@mytest_n: "0777",                  "%#o",           511
@mytest_n: "037777777001",          "%#o",           4294966785
@mytest_n: "0x1234abcd",            "%#x",           305441741
@mytest_n: "0xedcb5433",            "%#x",           3989525555
@mytest_n: "0X1234ABCD",            "%#X",           305441741
@mytest_n: "0XEDCB5433",            "%#X",           3989525555
@mytest_n: "0",                     "%#o",           0
@mytest_n: "0",                     "%#x",           0
@mytest_n: "0",                     "%#X",           0

@mytest_s: "Hallo heimur",          "%1s",           "Hallo heimur"
@mytest_n: "1024",                  "%1d",           1024
@mytest_n: "-1024",                 "%1d",           -1024
@mytest_n: "1024",                  "%1i",           1024
@mytest_n: "-1024",                 "%1i",           -1024
@mytest_n: "1024",                  "%1u",           1024
@mytest_n: "4294966272",            "%1u",           4294966272
@mytest_n: "777",                   "%1o",           511
@mytest_n: "37777777001",           "%1o",           4294966785
@mytest_n: "1234abcd",              "%1x",           305441741
@mytest_n: "edcb5433",              "%1x",           3989525555
@mytest_n: "1234ABCD",              "%1X",           305441741
@mytest_n: "EDCB5433",              "%1X",           3989525555

@skip: 1, "Character tests not applicable"
@mytest_s: "x",                     "%1c",           "x"

@mytest_s: "               Hallo",  "%20s",          "Hallo"
@mytest_n: "                1024",  "%20d",          1024
@mytest_n: "               -1024",  "%20d",          -1024
@mytest_n: "                1024",  "%20i",          1024
@mytest_n: "               -1024",  "%20i",          -1024
@mytest_n: "                1024",  "%20u",          1024
@mytest_n: "          4294966272",  "%20u",          4294966272
@mytest_n: "                 777",  "%20o",          511
@mytest_n: "         37777777001",  "%20o",          4294966785
@mytest_n: "            1234abcd",  "%20x",          305441741
@mytest_n: "            edcb5433",  "%20x",          3989525555
@mytest_n: "            1234ABCD",  "%20X",          305441741
@mytest_n: "            EDCB5433",  "%20X",          3989525555

@skip: 1, "Character tests not applicable"
@mytest_s: "                   x",  "%20c",          "x"

@mytest_s: "Hallo               ",  "%-20s",         "Hallo"
@mytest_n: "1024                ",  "%-20d",         1024
@mytest_n: "-1024               ",  "%-20d",         -1024
@mytest_n: "1024                ",  "%-20i",         1024
@mytest_n: "-1024               ",  "%-20i",         -1024
@mytest_n: "1024                ",  "%-20u",         1024
@mytest_n: "4294966272          ",  "%-20u",         4294966272
@mytest_n: "777                 ",  "%-20o",         511
@mytest_n: "37777777001         ",  "%-20o",         4294966785
@mytest_n: "1234abcd            ",  "%-20x",         305441741
@mytest_n: "edcb5433            ",  "%-20x",         3989525555
@mytest_n: "1234ABCD            ",  "%-20X",         305441741
@mytest_n: "EDCB5433            ",  "%-20X",         3989525555

@skip: 1, "Character tests not applicable"
@mytest_s: "x                   ",  "%-20c",         "x"

@mytest_n: "00000000000000001024",  "%020d",         1024
@mytest_n: "-0000000000000001024",  "%020d",         -1024
@mytest_n: "00000000000000001024",  "%020i",         1024
@mytest_n: "-0000000000000001024",  "%020i",         -1024
@mytest_n: "00000000000000001024",  "%020u",         1024
@mytest_n: "00000000004294966272",  "%020u",         4294966272
@mytest_n: "00000000000000000777",  "%020o",         511
@mytest_n: "00000000037777777001",  "%020o",         4294966785
@mytest_n: "0000000000001234abcd",  "%020x",         305441741
@mytest_n: "000000000000edcb5433",  "%020x",         3989525555
@mytest_n: "0000000000001234ABCD",  "%020X",         305441741
@mytest_n: "000000000000EDCB5433",  "%020X",         3989525555

@mytest_n: "                0777",  "%#20o",         511
@mytest_n: "        037777777001",  "%#20o",         4294966785
@mytest_n: "          0x1234abcd",  "%#20x",         305441741
@mytest_n: "          0xedcb5433",  "%#20x",         3989525555
@mytest_n: "          0X1234ABCD",  "%#20X",         305441741
@mytest_n: "          0XEDCB5433",  "%#20X",         3989525555

@mytest_n: "00000000000000000777",  "%#020o",        511
@mytest_n: "00000000037777777001",  "%#020o",        4294966785
@mytest_n: "0x00000000001234abcd",  "%#020x",        305441741
@mytest_n: "0x0000000000edcb5433",  "%#020x",        3989525555
@mytest_n: "0X00000000001234ABCD",  "%#020X",        305441741
@mytest_n: "0X0000000000EDCB5433",  "%#020X",        3989525555

@mytest_s: "Hallo               ",  "%0-20s",        "Hallo"
@mytest_n: "1024                ",  "%0-20d",        1024
@mytest_n: "-1024               ",  "%0-20d",        -1024
@mytest_n: "1024                ",  "%0-20i",        1024
@mytest_n: "-1024               ",  "%0-20i",        -1024
@mytest_n: "1024                ",  "%0-20u",        1024
@mytest_n: "4294966272          ",  "%0-20u",        4294966272
@mytest_n: "777                 ",  "%-020o",        511
@mytest_n: "37777777001         ",  "%-020o",        4294966785
@mytest_n: "1234abcd            ",  "%-020x",        305441741
@mytest_n: "edcb5433            ",  "%-020x",        3989525555
@mytest_n: "1234ABCD            ",  "%-020X",        305441741
@mytest_n: "EDCB5433            ",  "%-020X",        3989525555

@skip: 1, "Character tests not applicable"
@mytest_s: "x                   ",  "%-020c",        "x"

@mytest_ns: "               Hallo",  "%*s",           20, "Hallo"
@mytest_nn: "                1024",  "%*d",           20, 1024
@mytest_nn: "               -1024",  "%*d",           20, -1024
@mytest_nn: "                1024",  "%*i",           20, 1024
@mytest_nn: "               -1024",  "%*i",           20, -1024
@mytest_nn: "                1024",  "%*u",           20, 1024
@mytest_nn: "          4294966272",  "%*u",           20, 4294966272
@mytest_nn: "                 777",  "%*o",           20, 511
@mytest_nn: "         37777777001",  "%*o",           20, 4294966785
@mytest_nn: "            1234abcd",  "%*x",           20, 305441741
@mytest_nn: "            edcb5433",  "%*x",           20, 3989525555
@mytest_nn: "            1234ABCD",  "%*X",           20, 305441741
@mytest_nn: "            EDCB5433",  "%*X",           20, 3989525555

@skip: 1, "Character tests not applicable"
@mytest_ns: "                   x",  "%*c",           20, "x"

@mytest_s: "Hallo heimur",          "%.20s",         "Hallo heimur"
@mytest_n: "00000000000000001024",  "%.20d",         1024
@mytest_n: "-00000000000000001024", "%.20d",         -1024
@mytest_n: "00000000000000001024",  "%.20i",         1024
@mytest_n: "-00000000000000001024", "%.20i",         -1024
@mytest_n: "00000000000000001024",  "%.20u",         1024
@mytest_n: "00000000004294966272",  "%.20u",         4294966272
@mytest_n: "00000000000000000777",  "%.20o",         511
@mytest_n: "00000000037777777001",  "%.20o",         4294966785
@mytest_n: "0000000000001234abcd",  "%.20x",         305441741
@mytest_n: "000000000000edcb5433",  "%.20x",         3989525555
@mytest_n: "0000000000001234ABCD",  "%.20X",         305441741
@mytest_n: "000000000000EDCB5433",  "%.20X",         3989525555

@mytest_s: "               Hallo",  "%20.5s",        "Hallo heimur"
@mytest_n: "               01024",  "%20.5d",        1024
@mytest_n: "              -01024",  "%20.5d",        -1024
@mytest_n: "               01024",  "%20.5i",        1024
@mytest_n: "              -01024",  "%20.5i",        -1024
@mytest_n: "               01024",  "%20.5u",        1024
@mytest_n: "          4294966272",  "%20.5u",        4294966272
@mytest_n: "               00777",  "%20.5o",        511
@mytest_n: "         37777777001",  "%20.5o",        4294966785
@mytest_n: "            1234abcd",  "%20.5x",        305441741
@mytest_n: "          00edcb5433",  "%20.10x",       3989525555
@mytest_n: "            1234ABCD",  "%20.5X",        305441741
@mytest_n: "          00EDCB5433",  "%20.10X",       3989525555

# # This test is undefined. Common sense says libc fails it.
# #368 "               Hallo"  "%020.5s"       "Hallo heimur"
#  369 "               01024"  "%020.5d"       1024
#  370 "              -01024"  "%020.5d"       -1024
#  371 "               01024"  "%020.5i"       1024
#  372 "              -01024"  "%020.5i"       -1024
#  373 "               01024"  "%020.5u"       1024
#  374 "          4294966272"  "%020.5u"       4294966272
#  375 "               00777"  "%020.5o"       511
#  376 "         37777777001"  "%020.5o"       4294966785
#  377 "            1234abcd"  "%020.5x"       305441741
#  378 "          00edcb5433"  "%020.10x"      3989525555
#  379 "            1234ABCD"  "%020.5X"       305441741
#  380 "          00EDCB5433"  "%020.10X"      3989525555
#
#  381 ""                      "%.0s"          "Hallo heimur"
#  382 "                    "  "%20.0s"        "Hallo heimur"
#  383 ""                      "%.s"           "Hallo heimur"
#  384 "                    "  "%20.s"         "Hallo heimur"
#  385 "                1024"  "%20.0d"        1024
#  386 "               -1024"  "%20.d"         -1024
#  387 "                    "  "%20.d"         0
#  388 "                1024"  "%20.0i"        1024
#  389 "               -1024"  "%20.i"         -1024
#  390 "                    "  "%20.i"         0
#  391 "                1024"  "%20.u"         1024
#  392 "          4294966272"  "%20.0u"        4294966272
#  393 "                    "  "%20.u"         0
#  394 "                 777"  "%20.o"         511
#  395 "         37777777001"  "%20.0o"        4294966785
#  396 "                    "  "%20.o"         0
#  397 "            1234abcd"  "%20.x"         305441741
#  398 "            edcb5433"  "%20.0x"        3989525555
#  399 "                    "  "%20.x"         0
#  400 "            1234ABCD"  "%20.X"         305441741
#  401 "            EDCB5433"  "%20.0X"        3989525555
#  402 "                    "  "%20.X"         0
#
#  403 "Hallo               "  "% -0+*.*s"     20 5 "Hallo heimur"
#  404 "+01024              "  "% -0+*.*d"     20 5 1024
#  405 "-01024              "  "% -0+*.*d"     20 5 -1024
#  406 "+01024              "  "% -0+*.*i"     20 5 1024
#  407 "-01024              "  "% 0-+*.*i"     20 5 -1024
#  408 "01024               "  "% 0-+*.*u"     20 5 1024
#  409 "4294966272          "  "% 0-+*.*u"     20 5 4294966272
#  410 "00777               "  "%+ -0*.*o"     20 5 511
#  411 "37777777001         "  "%+ -0*.*o"     20 5 4294966785
#  412 "1234abcd            "  "%+ -0*.*x"     20 5 305441741
#  413 "00edcb5433          "  "%+ -0*.*x"     20 10 3989525555
#  414 "1234ABCD            "  "% -+0*.*X"     20 5 305441741
#  415 "00EDCB5433          "  "% -+0*.*X"     20 10 3989525555
#
# # Another GHC regression test
# 416 "hi x" "%*sx" -3 "hi"

@done_testing()
