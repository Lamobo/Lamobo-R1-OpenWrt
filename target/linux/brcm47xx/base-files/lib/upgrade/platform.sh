PART_NAME=firmware

# $(1): file to read magic from
# $(2): offset in bytes
get_magic_long_at() {
	dd if="$1" skip=$2 bs=1 count=4 2>/dev/null | hexdump -v -n 4 -e '1/1 "%02x"'
}

brcm47xx_identify() {
	local magic

	magic=$(get_magic_long "$1")
	case "$magic" in
		"48445230")
			echo "trx"
			return
			;;
		"2a23245e")
			echo "chk"
			return
			;;
	esac

	magic=$(get_magic_long_at "$1" 14)
	[ "$magic" = "55324e44" ] && {
		echo "cybertan"
		return
	}

	echo "unknown"
}

platform_check_image() {
	[ "$#" -gt 1 ] && return 1

	local file_type=$(brcm47xx_identify "$1")
	local magic

	case "$file_type" in
		"chk")
			local header_len=$((0x$(get_magic_long_at "$1" 4)))
			local board_id_len=$(($header_len - 40))
			local board_id=$(dd if="$1" skip=40 bs=1 count=$board_id_len 2>/dev/null | hexdump -v -e '1/1 "%c"')
			echo "Found CHK image with device board_id $board_id"

			magic=$(get_magic_long_at "$1" "$header_len")
			[ "$magic" != "48445230" ] && {
				echo "No valid TRX firmware in the CHK image"
				return 1
			}

			return 0
		;;
		"cybertan")
			magic=$(dd if="$1" bs=1 count=4 2>/dev/null | hexdump -v -e '1/1 "%c"')
			echo "Found CyberTAN image with device magic: $magic"

			magic=$(get_magic_long_at "$1" 32)
			[ "$magic" != "48445230" ] && {
				echo "No valid TRX firmware in the CyberTAN image"
				return 1
			}

			return 0
		;;
		"trx")
			return 0
		;;
		*)
			echo "Invalid image type. Please use only .trx files"
			return 1
		;;
	esac
}

platform_do_upgrade_chk() {
	local header_len=$((0x$(get_magic_long_at "$1" 4)))
	local trx="/tmp/$1.trx"

	dd if="$1" of="$trx" bs=$header_len skip=1
	shift
	default_do_upgrade "$trx" "$@"
}

platform_do_upgrade_cybertan() {
	local trx="/tmp/$1.trx"

	dd if="$1" of="$trx" bs=32 skip=1
	shift
	default_do_upgrade "$trx" "$@"
}

platform_do_upgrade() {
	local file_type=$(brcm47xx_identify "$1")

	case "$file_type" in
		"chk")		platform_do_upgrade_chk "$ARGV";;
		"cybertan")	platform_do_upgrade_cybertan "$ARGV";;
		*)		default_do_upgrade "$ARGV";;
	esac
}
