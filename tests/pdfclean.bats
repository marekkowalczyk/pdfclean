#!/usr/bin/env bats

# Path to the script under test
SCRIPT="$BATS_TEST_DIRNAME/../pdfclean"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

# Create a minimal valid-enough PDF in the current directory
make_pdf() {
    local name="${1:-test.pdf}"
    printf '%%PDF-1.4\n1 0 obj\n<</Type /Catalog>>\nendobj\ntrailer\n<</Root 1 0 R>>\n%%%%EOF\n' > "$name"
}

# Install a mock cpdf on PATH that copies input to output (no reduction)
# Invoked as: cpdf -squeeze <input> -o <output>
setup_mock_cpdf_noreduce() {
    cat > "$BATS_TEST_TMPDIR/cpdf" <<'EOF'
#!/usr/bin/env bash
# Mock: copies input to output unchanged (no size reduction)
cp -- "$2" "$4"
EOF
    chmod +x "$BATS_TEST_TMPDIR/cpdf"
    export PATH="$BATS_TEST_TMPDIR:$PATH"
}

# Install a mock cpdf that produces a smaller output
setup_mock_cpdf_reduce() {
    cat > "$BATS_TEST_TMPDIR/cpdf" <<'EOF'
#!/usr/bin/env bash
# Mock: writes a single byte (guaranteed smaller than any real PDF)
printf 'x' > "$4"
EOF
    chmod +x "$BATS_TEST_TMPDIR/cpdf"
    export PATH="$BATS_TEST_TMPDIR:$PATH"
}

# Install a mock cpdf that always fails
setup_mock_cpdf_fail() {
    cat > "$BATS_TEST_TMPDIR/cpdf" <<'EOF'
#!/usr/bin/env bash
exit 1
EOF
    chmod +x "$BATS_TEST_TMPDIR/cpdf"
    export PATH="$BATS_TEST_TMPDIR:$PATH"
}

setup() {
    # Each test gets its own temp working directory
    WORK="$BATS_TEST_TMPDIR/work"
    mkdir -p "$WORK"
    cd "$WORK"
}

# ---------------------------------------------------------------------------
# --help / --version
# ---------------------------------------------------------------------------

@test "--help exits 0 and prints usage" {
    run "$SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage:"* ]]
}

@test "--version exits 0 and prints version" {
    run "$SCRIPT" --version
    [ "$status" -eq 0 ]
    [[ "$output" == *"pdfclean"* ]]
}

# ---------------------------------------------------------------------------
# No-argument error
# ---------------------------------------------------------------------------

@test "no args exits 1 and prints error to stderr" {
    run "$SCRIPT"
    [ "$status" -eq 1 ]
    [[ "$output" == *"pdfclean:"* ]]
}

# ---------------------------------------------------------------------------
# Missing file
# ---------------------------------------------------------------------------

@test "missing file exits 1 with warning on stderr" {
    run "$SCRIPT" ghost.pdf
    [ "$status" -eq 1 ]
    [[ "$output" == *"not found"* ]]
}

# ---------------------------------------------------------------------------
# Duplicate file warning
# ---------------------------------------------------------------------------

@test "duplicate filename warned and processed once" {
    setup_mock_cpdf_reduce
    make_pdf a.pdf
    run "$SCRIPT" a.pdf a.pdf
    [ "$status" -eq 0 ]
    [[ "$output" == *"more than once"* ]]
    # Reduction report should appear exactly once
    count=$(echo "$output" | grep -c "reduced by")
    [ "$count" -eq 1 ]
}

# ---------------------------------------------------------------------------
# . / --all / -a
# ---------------------------------------------------------------------------

@test ". picks up *.pdf files" {
    setup_mock_cpdf_reduce
    make_pdf one.pdf
    make_pdf two.pdf
    run "$SCRIPT" .
    [ "$status" -eq 0 ]
    [[ "$output" == *"one.pdf"* ]]
    [[ "$output" == *"two.pdf"* ]]
}

@test "--all is equivalent to ." {
    setup_mock_cpdf_reduce
    make_pdf one.pdf
    run "$SCRIPT" --all
    [ "$status" -eq 0 ]
    [[ "$output" == *"one.pdf"* ]]
}

@test "-a is equivalent to ." {
    setup_mock_cpdf_reduce
    make_pdf one.pdf
    run "$SCRIPT" -a
    [ "$status" -eq 0 ]
    [[ "$output" == *"one.pdf"* ]]
}

@test ". picks up *.PDF files" {
    setup_mock_cpdf_reduce
    make_pdf UPPER.PDF
    run "$SCRIPT" .
    [ "$status" -eq 0 ]
    [[ "$output" == *"UPPER.PDF"* ]]
}

@test ". with no PDFs exits 1" {
    run "$SCRIPT" .
    [ "$status" -eq 1 ]
    [[ "$output" == *"no PDF files found"* ]]
}

@test "combining . with explicit file exits 1" {
    make_pdf a.pdf
    run "$SCRIPT" . a.pdf
    [ "$status" -eq 1 ]
    [[ "$output" == *"cannot combine"* ]]
}

# ---------------------------------------------------------------------------
# -- end-of-options
# ---------------------------------------------------------------------------

@test "-- allows filename starting with -" {
    setup_mock_cpdf_reduce
    make_pdf "-odd.pdf"
    run "$SCRIPT" -- -odd.pdf
    [ "$status" -eq 0 ]
    [[ "$output" == *"-odd.pdf"* ]]
}

# ---------------------------------------------------------------------------
# --dry-run / -n
# ---------------------------------------------------------------------------

@test "--dry-run does not modify file" {
    setup_mock_cpdf_reduce
    make_pdf a.pdf
    original=$(cat a.pdf)
    run "$SCRIPT" --dry-run a.pdf
    [ "$status" -eq 0 ]
    [ "$(cat a.pdf)" = "$original" ]
}

@test "-n is alias for --dry-run" {
    setup_mock_cpdf_reduce
    make_pdf a.pdf
    original=$(cat a.pdf)
    run "$SCRIPT" -n a.pdf
    [ "$status" -eq 0 ]
    [ "$(cat a.pdf)" = "$original" ]
}

@test "--dry-run reports reduction when mock reduces" {
    setup_mock_cpdf_reduce
    make_pdf a.pdf
    run "$SCRIPT" --dry-run a.pdf
    [ "$status" -eq 0 ]
    [[ "$output" == *"would reduce"* ]]
}

@test "--dry-run is silent when mock does not reduce" {
    setup_mock_cpdf_noreduce
    make_pdf a.pdf
    run "$SCRIPT" --dry-run a.pdf
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

# ---------------------------------------------------------------------------
# Compression outcomes
# ---------------------------------------------------------------------------

@test "file is replaced when mock produces smaller output" {
    setup_mock_cpdf_reduce
    make_pdf a.pdf
    run "$SCRIPT" a.pdf
    [ "$status" -eq 0 ]
    [[ "$output" == *"reduced by"* ]]
    # File should now be 1 byte (what mock wrote)
    [ "$(wc -c < a.pdf | tr -d ' ')" -eq 1 ]
}

@test "file is kept when mock produces no reduction" {
    setup_mock_cpdf_noreduce
    make_pdf a.pdf
    original=$(cat a.pdf)
    run "$SCRIPT" a.pdf
    [ "$status" -eq 0 ]
    [ -z "$output" ]
    [ "$(cat a.pdf)" = "$original" ]
}

@test "cpdf -squeeze failure exits 1 with error message" {
    setup_mock_cpdf_fail
    make_pdf a.pdf
    run "$SCRIPT" a.pdf
    [ "$status" -eq 1 ]
    [[ "$output" == *"pdfclean:"* ]]
}

@test "no orphaned temp files after cpdf -squeeze failure" {
    setup_mock_cpdf_fail
    make_pdf a.pdf
    run "$SCRIPT" a.pdf
    # No .pdfclean.* temp files should remain
    leftover=$(ls .pdfclean.* 2>/dev/null | wc -l | tr -d ' ')
    [ "$leftover" -eq 0 ]
}

# ---------------------------------------------------------------------------
# --quiet / -q
# ---------------------------------------------------------------------------

@test "--quiet produces no stdout on success" {
    setup_mock_cpdf_noreduce
    make_pdf a.pdf
    run "$SCRIPT" --quiet a.pdf
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "-q is alias for --quiet" {
    setup_mock_cpdf_noreduce
    make_pdf a.pdf
    run "$SCRIPT" -q a.pdf
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "--quiet still exits 1 on missing file" {
    run "$SCRIPT" -q ghost.pdf
    [ "$status" -eq 1 ]
}

# ---------------------------------------------------------------------------
# Exit code: partial failure
# ---------------------------------------------------------------------------

@test "exit 1 when some files fail and some succeed" {
    setup_mock_cpdf_noreduce
    make_pdf good.pdf
    run "$SCRIPT" good.pdf ghost.pdf
    [ "$status" -eq 1 ]
}
