/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

// HINT 1 : TRAPHANDLER_NOEC(t_divide, T_DIVIDE);
//          Do something like this if there is no error code for the trap
// HINT 2 : TRAPHANDLER(t_dblflt, T_DBLFLT);
//          Do something like this if the trap includes an error code..
// HINT 3 : READ Intel's manual to check if the trap includes an error code
//          or not...

TRAPHANDLER_NOEC(t_divide, T_DIVIDE)
TRAPHANDLER_NOEC(t_debug, T_DEBUG)
TRAPHANDLER_NOEC(t_nmi, T_NMI)
TRAPHANDLER_NOEC(t_brkpt, T_BRKPT)
TRAPHANDLER_NOEC(t_oflow, T_OFLOW)
TRAPHANDLER_NOEC(t_bound, T_BOUND)
TRAPHANDLER_NOEC(t_illop, T_ILLOP)
TRAPHANDLER_NOEC(t_device, T_DEVICE)
TRAPHANDLER(t_dblflt, T_DBLFLT)
TRAPHANDLER(t_tss, T_TSS)
TRAPHANDLER(t_segnp, T_SEGNP)
TRAPHANDLER(t_stack, T_STACK)
TRAPHANDLER(t_gpflt, T_GPFLT)
TRAPHANDLER(t_pgflt, T_PGFLT)
TRAPHANDLER_NOEC(t_fperr, T_FPERR)
TRAPHANDLER(t_align, T_ALIGN)
TRAPHANDLER_NOEC(t_mchk, T_MCHK)
TRAPHANDLER_NOEC(t_simderr, T_SIMDERR)
TRAPHANDLER_NOEC(t_syscall, T_SYSCALL)

TRAPHANDLER_NOEC(t_irq_timer, IRQ_OFFSET + IRQ_TIMER)
TRAPHANDLER_NOEC(t_irq_kbd, IRQ_OFFSET + IRQ_KBD)
TRAPHANDLER_NOEC(t_irq_2, IRQ_OFFSET + 2)
TRAPHANDLER_NOEC(t_irq_3, IRQ_OFFSET + 3)
TRAPHANDLER_NOEC(t_irq_serial, IRQ_OFFSET + IRQ_SERIAL)
TRAPHANDLER_NOEC(t_irq_5, IRQ_OFFSET + 5)
TRAPHANDLER_NOEC(t_irq_6, IRQ_OFFSET + 6)
TRAPHANDLER_NOEC(t_irq_spurious, IRQ_OFFSET + IRQ_SPURIOUS)
TRAPHANDLER_NOEC(t_irq_8, IRQ_OFFSET + 8)
TRAPHANDLER_NOEC(t_irq_9, IRQ_OFFSET + 9)
TRAPHANDLER_NOEC(t_irq_10, IRQ_OFFSET + 10)
TRAPHANDLER_NOEC(t_irq_11, IRQ_OFFSET + 11)
TRAPHANDLER_NOEC(t_irq_12, IRQ_OFFSET + 12)
TRAPHANDLER_NOEC(t_irq_13, IRQ_OFFSET + 13)
TRAPHANDLER_NOEC(t_irq_ide, IRQ_OFFSET + IRQ_IDE)
TRAPHANDLER_NOEC(t_irq_15, IRQ_OFFSET + 15)

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushl %ds;
	pushl %es;
	pushal;
	pushl $GD_KD;
	popl %ds;
    pushl $GD_KD;
    popl %es;
    pushl %esp;
    call trap;

