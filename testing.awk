#!/usr/bin/awk -f
BEGIN { FS = ","; }
        /foundip/{   coo[$2]["IP"] = $2; coo[$2]["Country"] = $3; coo[$2]["foundip"] = $4 }
END {
        for (i in coo) {
              printf "IP %-15s from: %-20s have Attempted: %-6s been Banned: %-6s and Unbanned: %-6s \n", coo[i]["IP"], coo[i]["Country"], coo[i]["foundip"], coo[i]["banip"], coo[i]["unban"];
          }
      }
