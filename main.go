package main

import (
	"fmt"
	"net/url"
	"strings"
)

// This small app creates valid query for clickhouse http-reguest like:
// 'http://clickhousebd:8123?query=${TRANSFORMED_QUERY}'
func main() {
	query := s

	query = strings.TrimSpace(query)

	query = strings.Replace(query, "\n", " ", -1)
	query = strings.Replace(query, "\t", " ", -1)

	for i := 0; i < 10; i++ {
		query = strings.Replace(query, "  ", " ", -1)
	}

	query = strings.Replace(query, " )", ")", -1)
	query = strings.Replace(query, "( ", "(", -1)

	transformedQuery := url.PathEscape(query)
	fmt.Println(transformedQuery)
}

//language=sql
var s = `
SELECT 
    sum(num) AS num,
    status,
    host_addr
FROM 
(
    SELECT 
        sum(1) AS num, 
        status, 
        host_addr
    FROM viewers 
    WHERE time > (now() - (60 * 5))
    GROUP BY  
        status, 
        host_addr

    UNION ALL

    SELECT 
        sum(1) AS num, 
        status, 
        host_addr
    FROM viewers_unparsed 
    WHERE (date >= yesterday()) AND (time > (now() - (60 * 5)))
    GROUP BY 
        status, 
        host_addr
) 
GROUP BY 
    status, 
    host_addr
ORDER BY status
FORMAT JSONEachRow
`
