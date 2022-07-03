B='#00000000'  # blank
C='#ffffff00'  # clear ish
D='#00ffffff'  # default
T='#00eeeeff'  # text
W='#ff0000ff'  # wrong
V='#00bbbbff'  # verifying

xset s off dpms 0 10 120

i3lock-color \
--color=000000 \
\
--insidever-color=$C   \
--ringver-color=$V     \
\
--insidewrong-color=$C \
--ringwrong-color=$W   \
\
--inside-color=$B      \
--ring-color=$D        \
--line-color=$B        \
--separator-color=$D   \
\
--verif-color=$T        \
--wrong-color=$T        \
--time-color=$T        \
--date-color=$T        \
--layout-color=$T      \
--keyhl-color=$W       \
--bshl-color=$W        \
\
--clock               \
--indicator           \
--time-str="%H:%M:%S"  \
--date-str="%A, %d/%m/%y" \
--keylayout 0         \
\
--ignore-empty-password \
\
--verif-text="checking" \
--wrong-text="WRONG" \
\
--radius=100

xset s off -dpms
