asm(R"(
.globl func
    .type func, @function
    func:
    .cfi_startproc
    movl $7, %eax
    retl
    .cfi_endproc
)");
 
int main()
{
    int n = func();
    // extended inline assembly
    asm ("leal (%0,%0,4),%0"
         : "=r" (n)
         : "0" (n));
 
    // standard inline assembly
    asm ("movq $60, %rax\n\t" // the exit syscall number on Linux
         "movq $2,  %rdi\n\t" // this program returns 2
         "syscall");
}