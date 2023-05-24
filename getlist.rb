require 'open3'
@file = "list.txt"
#uncomment line bellow if need create file
File.new(@file, "w+")

def getNodes() 
    command = "kubectl get nodes -o custom-columns=NAME:.metadata.name" 
    stdin, stderr, exitstatus = Open3.capture3(command)
    get_output = stdin.split
    get_output.slice(1, get_output.count)
end

def getPods(node)
    command = "kubectl get pods --all-namespaces -o wide --field-selector spec.nodeName=" + node
    stdin, stderr, exitstatus = Open3.capture3(command)
    stdin
end

def displayToConsole(w, no, node, pods)
    print no
    puts " ). "+ node
    puts pods
    puts "============================== END #{node} ==============================" 
    puts "";
    puts "";
    puts "";
end

def writeToFile(w, no, node, pods)
    w.puts("#{no} ). NODE = #{node}")
    w.puts( "============================== START #{node} ==============================")
    w.puts("#{pods}")
    w.puts( "============================== END #{node} ================================")
    w.puts("")
    w.puts("")
    w.puts("")
end

def listPods(list)
    File.open(@file, "w+") do |w|    
        no = 1
        list.each { |node|
            pods =  getPods(node)
            #display to console
            displayToConsole(w, no, node, pods)
            #write to file
            writeToFile(w, no, node, pods)
            no = no + 1
        }
    end
end

step1 = getNodes()
puts "=============================="
puts "count of node = #{step1.count}"
puts "=============================="
puts "";
puts "";

listPods(step1);

puts "";
puts "";
puts "";
puts "END OF FILE";


