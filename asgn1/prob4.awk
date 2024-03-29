BEGIN{
    
    color[1] = "Red"
    color[2] = "White"
    color[3] = "Black"
    
}

/^\s*\t*[0-9]+\s*\t*$/{

    gsub(/\t+/, "")
    gsub(/\s+/, "")
    vertices = $0
    
    for(i = 1; i <= vertices; i++){
        for(j = 1; j <= 3 ; j++){
            verticeColor[i,j] = "V"i color[j]
        }
    } 

    output = ""
    for(i = 1 ; i <= vertices ; i++){
            output = output"("verticeColor[i,1]" | "verticeColor[i,2]" | "verticeColor[i,3]") & "
    }
    output = substr(output, 1, length(output)-3)

    for(i = 1; i <= vertices; i++){
        clause = ""
        for(j = 1; j<= length(color); j++){
            pos1 = (j % 3) + 1
            pos2 = (j + 1) % 3 + 1
            clause = clause" & (~" verticeColor[i,pos1] "| ~" verticeColor[i,pos2] ")"
        }
        output = output""clause
    }

    store_outputs = store_outputs""output
}

/^\s*[0-9]+\s*--\s*[0-9]+\s*$/{   
    
    gsub(/\s+/,"")
    gsub(/\t+/, "")

    split($0, nodes, "--")
    
    for(i = 1; i <= length(color) ; i++){
        result = ""
        current = nodes[1]
        next_node = nodes[2]
        result  = result " & (~"verticeColor[current,i]"| ~"verticeColor[next_node,i]")"
        store_outputs = store_outputs""result
    }    
}

END{
    print("sage -c 'print(propcalc.formula(\""store_outputs"\").is_satisfiable())'") > "prob4_ans.txt"
}
        


    


