#!/usr/bin/env bash
ROOT=$( dirname "$( realpath -m "${BASH_SOURCE[0]}" )" )

ERRORS=0

CHARTS=$(ls ${ROOT}/)
for CHART in ${CHARTS}; do
    if [ -d ${ROOT}/${CHART}/tests ]; then
        echo "Testing chart ${CHART}..."
        if [ -d ${ROOT}/${CHART}/tests/succes ]; then
            TESTS=$(ls ${ROOT}/${CHART}/tests/succes/)
            for TEST in ${TESTS}; do
                echo -n "  Test ${TEST}..."
                KUBECONFIG="" helm template ${ROOT}/${CHART} --values ${ROOT}/${CHART}/tests/succes/${TEST}/values.yaml > ${ROOT}/${CHART}/tests/succes/${TEST}/result.yaml
                DIFF="$(diff -u ${ROOT}/${CHART}/tests/succes/${TEST}/expected.yaml ${ROOT}/${CHART}/tests/succes/${TEST}/result.yaml)"
                if [ $? -ne 0 ]; then
                    ERRORS=1
                    echo -e " \e[31mfailed\e[0m:"
                    echo "${DIFF}"
                else
                    echo -e " \e[32mok\e[0m."
                fi
            done
        fi
        if [ -d ${ROOT}/${CHART}/tests/fail ]; then
            TESTS=$(ls ${ROOT}/${CHART}/tests/fail/)
            for TEST in ${TESTS}; do
                echo -n "  Test ${TEST}..."
                KUBECONFIG="" helm template ${ROOT}/${CHART} --values ${ROOT}/${CHART}/tests/fail/${TEST}/values.yaml 2>/dev/null
                if [ $? -eq 0 ]; then
                    ERRORS=1
                    echo -e " \e[31mfailed\e[0m:"
                    echo "Template should fail, but succeeded."
                else
                    echo -e " \e[32mok\e[0m."
                fi
            done
        fi
    fi
done

exit ${ERRORS}
