# ---------------------------------------------------------- #
# Title: Multi-layer Windowed app example
# Description: Demonstrate using  multi-line textboxes
# ChangeLog (Who,When,What):
# ESung,05.28.2020,Created started script
# ---------------------------------------------------------- #
import tkinter as tk
from tkinter import ttk

class MathProcessor(object):
    @staticmethod
    def add(n1, n2):
        return n1 + n2

    @staticmethod
    def subtract(n1, n2):
        return n1 - n2

    @staticmethod
    def multiply(n1, n2):
        return n1 * n2

    @staticmethod
    def divide(n1, n2):
        return n1 / n2


class MathIO(object):

    @staticmethod
    def clear_textbox(textbox):
        textbox['state'] = 'normal'
        textbox.delete(1.0, tk.END)
        textbox['state'] = 'disabled'


    @staticmethod
    def write_sum_to_textbox(n1, n2, textbox):
        textbox['state'] = 'normal'
        text = str.format('The Sum of {n1} and {n2} is {result}\n',
                          n1=n1, n2=n2, result=MathProcessor.add(n1, n2))
        textbox.insert(tk.END, text)
        textbox['state'] = 'disabled'

    @staticmethod
    def write_difference_to_textbox(n1, n2, textbox):
        textbox['state'] = 'normal'
        text = str.format('The difference of {n1} and {n2} is {result}\n',
                          n1=n1, n2=n2, result=MathProcessor.subtract(n1, n2))
        textbox.insert(tk.END, text)
        textbox['state'] = 'disabled'

    @staticmethod
    def write_product_to_textbox(n1, n2, textbox):
        textbox['state'] = 'normal'
        text = str.format('The product of {n1} and {n2} is {result}\n',
                          n1=n1, n2=n2, result=MathProcessor.multiply(n1, n2))
        textbox.insert(tk.END, text)
        textbox['state'] = 'disabled'

    @staticmethod
    def write_quotient_to_textbox(n1, n2, textbox):
        textbox['state'] = 'normal'
        text = str.format('The quotient of {n1} and {n2} is {result}\n',
                          n1=n1, n2=n2, result=MathProcessor.divide(n1, n2))
        textbox.insert(tk.END, text)
        textbox['state'] = 'disabled'
# End class

class MainWindow(object):
    """  Description: Creates the following UI objects:
    window_root (tk.TK)
        lbl_math_info (ttk.label)
        txt_first_number (ttk.entry)
        txt_second_number (ttk.entry)
        mtx_results (ttk.textbox)
        btn_add (ttk.button)
        btn_subtract (ttk.button)
        btn_multiply (ttk.button)
        btn_divide (ttk.button)
    """
    @staticmethod
    def create_main_window():
        """ Create  and configure a root node Window object"""
        application_window = tk.Tk()
        application_window.geometry("425x250")
        application_window.title("Simple Math")

        lbl_math_results = ttk.Label(application_window, text="Math Results")
        lbl_math_results.grid(row=1, column=1, sticky=tk.NW, padx=10, pady=5)

        lbl_first_number = ttk.Label(
            application_window,
            text="First Number ",
            width=20,
            anchor=tk.E
        )
        lbl_first_number.grid(row=2, column=1, sticky=tk.E)
        txt_first_number = ttk.Entry(application_window, width=40)
        txt_first_number.grid(row=2, column=2, columnspan=3)
        txt_first_number.insert(0, "0.00")

        lbl_second_number = ttk.Label(
            application_window,
            text="Second Number ",
            width=20,
            anchor=tk.E
        )
        lbl_second_number.grid(row=3, column=1, sticky=tk.E)
        txt_second_number = ttk.Entry(application_window, width=40)
        txt_second_number.grid(row=3, column=2, columnspan=3)
        txt_second_number.insert(0, "0.00")

        # Adding a multi-line textbox
        mtx_results = tk.Text(width=50, height=5)
        mtx_results.grid(row=4,
            column=1,
            sticky=tk.N,
            columnspan=4,
            padx = 10,
            pady =10
            )

        btn_add = ttk.Button(application_window, text="Add", width=10)
        btn_add.grid(row=5, column=1, sticky=tk.E, padx=15, pady=5)
        btn_add['command'] = lambda: MathIO.write_sum_to_textbox(
            float(txt_first_number.get()),
            float(txt_second_number.get()),
            mtx_results)

        btn_subtract = ttk.Button(application_window, text="Subtract", width=10)
        btn_subtract.grid(row=5, column=2, sticky=tk.W, padx=5, pady=5)
        btn_subtract['command'] = lambda:  MathIO.write_difference_to_textbox(
            float(txt_first_number.get()),
            float(txt_second_number.get()),
            mtx_results)


        btn_multiply = ttk.Button(application_window, text="Multiply", width=10)
        btn_multiply.grid(row=5, column=3, sticky=tk.W, padx=5, pady=5)
        btn_multiply['command'] = lambda:  MathIO.write_product_to_textbox(
            float(txt_first_number.get()),
            float(txt_second_number.get()),
            mtx_results)


        btn_divide = ttk.Button(application_window, text="Divide", width=10)
        btn_divide.grid(row=5, column=4, sticky=tk.W, padx=5, pady=5)
        btn_divide['command'] = lambda:  MathIO.write_quotient_to_textbox(
            float(txt_first_number.get()),
            float(txt_second_number.get()),
            mtx_results)


        btn_divide = ttk.Button(application_window, text="Clear Results", width=55)
        btn_divide.grid(row=6, column=1,  padx=15, pady=5, columnspan=4)
        btn_divide['command'] = lambda: MathIO.clear_textbox(mtx_results)
        return application_window
# End class

if __name__ == '__main__':
    mw = MainWindow.create_main_window()
    mw.mainloop()

