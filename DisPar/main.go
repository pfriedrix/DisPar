package main

/*
#include <fcntl.h>
#include <sys/stat.h>
#include <mqueue.h>
*/
import "C"

import (
	"fmt"
	"unsafe"
)

func main() {
	mqName := "/my_queue"
	mqFlags := C.O_CREAT | C.O_RDWR
	mqMode := C.S_IRUSR | C.S_IWUSR
	mqMaxMsg := C.int(10)
	mqMsgSize := C.int(8192)

	// Створення черги повідомлень
	mq, err := C.mq_open(C.CString(mqName), mqFlags, mqMode, nil)
	if err != nil {
		panic(err)
	}
	defer C.mq_close(mq)

	// Відправка повідомлення
	msg := []byte("Hello, World!")
	err = C.mq_send(mq, (*C.char)(unsafe.Pointer(&msg[0])), mqMsgSize, 0)
	if err != nil {
		panic(err)
	}

	// Отримання повідомлення
	buf := make([]byte, 8192)
	n, err := C.mq_receive(mq, (*C.char)(unsafe.Pointer(&buf[0])), mqMsgSize, nil)
	if err != nil {
		panic(err)
	}

	fmt.Printf("Received message: %s\n", string(buf[:n]))

	// Видалення черги повідомлень
	err = C.mq_unlink(C.CString(mqName))
	if err != nil {
		panic(err)
	}
}
