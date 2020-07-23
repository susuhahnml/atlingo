#!/usr/bin/python -u

import optparse
import threading
import subprocess
import os
import sys
import signal
import time

queue = ['results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y9_r20/x10_y9_n90_r20_s20_ps1_pr20_u20_o20_l20_N004.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y9_r20/x10_y9_n90_r20_s20_ps1_pr20_u20_o20_l20_N002.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y9_r20/x10_y9_n90_r20_s20_ps1_pr20_u20_o20_l20_N003.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y9_r20/x10_y9_n90_r20_s20_ps1_pr20_u20_o20_l20_N001.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y9_r20/x10_y9_n90_r20_s20_ps1_pr20_u20_o20_l20_N005.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y12_r20/x10_y12_n120_r20_s20_ps1_pr20_u20_o20_l20_N002.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y12_r20/x10_y12_n120_r20_s20_ps1_pr20_u20_o20_l20_N001.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y12_r20/x10_y12_n120_r20_s20_ps1_pr20_u20_o20_l20_N005.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y12_r20/x10_y12_n120_r20_s20_ps1_pr20_u20_o20_l20_N003.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y12_r20/x10_y12_n120_r20_s20_ps1_pr20_u20_o20_l20_N004.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x7_y6_r2/x7_y6_n42_r2_s4_ps1_pr4_u4_o4_l4_N001.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x7_y6_r4/x7_y6_n42_r4_s4_ps1_pr4_u4_o4_l4_N001.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x7_y6_r4/x7_y6_n42_r4_s4_ps1_pr4_u4_o4_l4_N004.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x7_y6_r4/x7_y6_n42_r4_s4_ps1_pr4_u4_o4_l4_N003.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x7_y6_r4/x7_y6_n42_r4_s4_ps1_pr4_u4_o4_l4_N005.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x7_y6_r4/x7_y6_n42_r4_s4_ps1_pr4_u4_o4_l4_N002.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y10_r20/x10_y10_n100_r20_s20_ps1_pr20_u20_o20_l20_N005.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y10_r20/x10_y10_n100_r20_s20_ps1_pr20_u20_o20_l20_N004.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y10_r20/x10_y10_n100_r20_s20_ps1_pr20_u20_o20_l20_N001.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y10_r20/x10_y10_n100_r20_s20_ps1_pr20_u20_o20_l20_N003.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y10_r20/x10_y10_n100_r20_s20_ps1_pr20_u20_o20_l20_N002.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y6_r10/x10_y6_n60_r10_s10_ps1_pr10_u10_o10_l10_N003.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y6_r10/x10_y6_n60_r10_s10_ps1_pr10_u10_o10_l10_N002.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y6_r10/x10_y6_n60_r10_s10_ps1_pr10_u10_o10_l10_N001.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y6_r10/x10_y6_n60_r10_s10_ps1_pr10_u10_o10_l10_N004.lp/run1/start.sh','results/asprilo-benchmarkk/to_automata_and_runs-1-without-constraint_h_15/x10_y6_r10/x10_y6_n60_r10_s10_ps1_pr10_u10_o10_l10_N005.lp/run1/start.sh']

class Main:
    def __init__(self):
        self.running  = set()
        self.cores    = set()
        self.started  = 0
        self.total    = None
        self.finished = threading.Condition()
        self.coreLock = threading.Lock()
        c = 0
        while len(self.cores) < 1:
            self.cores.add(c)
            c += 1
    
    def finish(self, thread):
        self.finished.acquire()
        self.running.remove(thread)
        with self.coreLock:
            self.cores.add(thread.core)
        self.finished.notify()
        self.finished.release()
   
    def start(self, cmd):
        core     = 0
        with self.coreLock:
            core = self.cores.pop()
        thread = Run(cmd, self, core)
        self.started += 1
        self.running.add(thread)
        print("({0}/{1}/{2}/{4}) {3}".format(len(self.running), self.started, self.total, cmd, core))
        thread.start()
    
    def run(self, queue):
        signal.signal(signal.SIGTERM, self.exit)
        signal.signal(signal.SIGINT, self.exit)
        signal.signal(signal.SIGHUP, signal.SIG_IGN)
        self.finished.acquire()
        self.total = len(queue)
        for cmd in queue:
            while len(self.running) >= 1:
                self.finished.wait()
            self.start(cmd)
        while len(self.running) != 0:
            self.finished.wait()
        self.finished.release()

    def exit(self, *args):
        signal.signal(signal.SIGINT, signal.SIG_IGN)
        signal.signal(signal.SIGTERM, signal.SIG_IGN)
        print "WARNING: it is not guaranteed that all processes will be terminated!"
        print "sending sigterm ..."
        os.killpg(os.getpgid(0), signal.SIGTERM)
        print "waiting 10s..."
        time.sleep(10)
        print "sending sigkill ..."
        os.killpg(os.getpgid(0), signal.SIGKILL)

class Run(threading.Thread):
    def __init__(self, cmd, main, core):
        threading.Thread.__init__(self)
        self.cmd  = cmd
        self.main = main
        self.core = core
        self.proc = None
    
    def run(self):
        path, script = os.path.split(self.cmd)
        self.proc = subprocess.Popen(["bash", script, str(self.core)], cwd=path)
        self.proc.wait()
        self.main.finish(self)

def gui():
    import Tkinter
    class App:
        def __init__(self):
            root    = Tkinter.Tk()
            frame   = Tkinter.Frame(root)
            scrollx = Tkinter.Scrollbar(frame, orient=Tkinter.HORIZONTAL)
            scrolly = Tkinter.Scrollbar(frame)
            list    = Tkinter.Listbox(frame, selectmode=Tkinter.MULTIPLE)
            
            for script in queue:
                list.insert(Tkinter.END, script)
            
            scrolly.config(command=list.yview)
            scrollx.config(command=list.xview)
            list.config(yscrollcommand=scrolly.set)
            list.config(xscrollcommand=scrollx.set)
                
            scrolly.pack(side=Tkinter.RIGHT, fill=Tkinter.Y)
            scrollx.pack(side=Tkinter.BOTTOM, fill=Tkinter.X)
            list.pack(fill=Tkinter.BOTH, expand=1)
            
            button = Tkinter.Button(root, text='Run', command=self.pressed)
            
            frame.pack(fill=Tkinter.BOTH, expand=1)
            button.pack(side=Tkinter.BOTTOM, fill=Tkinter.X)

            self.root  = root
            self.list  = list
            self.run   = False
            self.queue = [] 
        
        def pressed(self):
            sel = self.list.curselection()
            for index in sel:
                global queue
                self.queue.append(queue[int(index)])
            self.root.destroy()

        def start(self):
            self.root.mainloop()
            return self.queue

    global queue
    queue.sort()
    queue = App().start()

if __name__ == '__main__':
    usage  = "usage: %prog [options] <runscript>"
    parser = optparse.OptionParser(usage=usage)
    parser.add_option("-g", "--gui", action="store_true", dest="gui", default=False, help="start gui to selectively start benchmarks") 

    opts, args = parser.parse_args(sys.argv[1:])
    if len(args) > 0: parser.error("no arguments expected")
    
    os.chdir(os.path.dirname(sys.argv[0]))
    if opts.gui: gui()

    m = Main()
    m.run(queue)
