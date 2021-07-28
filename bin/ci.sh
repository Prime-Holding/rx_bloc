#!/usr/bin/env sh

CURRENT_DIR=$(pwd)
cd packages/rx_bloc && bin/ci.sh && cd "$CURRENT_DIR" || exit
cd packages/rx_bloc_generator && bin/ci.sh && cd "$CURRENT_DIR" || exit
cd packages/rx_bloc_test && bin/ci.sh && cd "$CURRENT_DIR" || exit

cd examples/booking_app && bin/ci.sh && cd "$CURRENT_DIR" || exit
cd examples/counter && bin/ci.sh && cd "$CURRENT_DIR" || exit
cd examples/division && bin/ci.sh && cd "$CURRENT_DIR" || exit
cd examples/favorites_advanced/rx_bloc_favorites_advanced && bin/ci.sh && cd "$CURRENT_DIR" || exit
cd packages/rx_bloc_list && bin/ci.sh && cd "$CURRENT_DIR" || exit
