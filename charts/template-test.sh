#!/usr/bin/env bash
ROOT=$( dirname "$( realpath -m "${BASH_SOURCE[0]}" )" )

ERRORS=0

CHARTS=$(ls ${ROOT}/)
for CHART in ${CHARTS}; do
    if [ -d ${ROOT}/${CHART}/tests ]; then
        echo "Testing chart ${CHART}..."
        TESTS=$(ls ${ROOT}/${CHART}/tests/)
        for TEST in ${TESTS}; do
            echo -n "  Test ${TEST}..."
            KUBECONFIG="" helm template ${ROOT}/${CHART} --values ${ROOT}/${CHART}/tests/${TEST}/values.yaml > ${ROOT}/${CHART}/tests/${TEST}/result.yaml
            DIFF="$(diff -u ${ROOT}/${CHART}/tests/${TEST}/expected.yaml ${ROOT}/${CHART}/tests/${TEST}/result.yaml)"
            if [ $? -ne 0 ]; then
                ERRORS=1
                echo -e " \e[31mfailed\e[0m:"
                echo "${DIFF}"
            else
                echo -e " \e[32mok\e[0m."
            fi
        done
    fi
done

exit ${ERRORS}
