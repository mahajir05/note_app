import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../infrastructure/theme/colors.dart';

class FormUtils {
  static Widget textField({
    Key? key,
    required String hint,
    IconData? icon,
    FormFieldValidator<String>? validator,
    TextEditingController? textEditingController,
    bool obscure = false,
    bool readonly = false,
    bool showicon = false,
    Function()? ontap,
    TextInputType keyboardtype = TextInputType.text,
    int? maxlength,
    int maxLines = 1,
  }) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      maxLines: maxLines,
      maxLength: maxlength,
      readOnly: readonly,
      obscureText: obscure,
      keyboardType: keyboardtype,
      onTap: readonly ? ontap : null,
      controller: textEditingController,
      style: Get.textTheme.headline1?.copyWith(
        fontSize: 9.sp,
        color: Appcolors.black,
      ),
      decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.grey.shade200,
                width: 0,
              )),
          contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.3.h),
          hintStyle: Get.textTheme.headline1?.copyWith(
            fontSize: 9.sp,
            color: Colors.deepPurple,
          ),
          prefixIcon: showicon
              ? Icon(
                  icon,
                  size: 22,
                  color: Colors.deepPurple,
                )
              : null,
          suffixIcon: readonly
              ? Icon(
                  icon,
                  size: 22,
                  color: Colors.deepPurple,
                )
              : null),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
    );
  }

  static Widget radio<T>({
    String? textLabel,
    required T group,
    required List<T> dataList,
    required Widget Function(T) title,
    required Function(T?) onChanged,
  }) {
    return Row(
      children: <Widget>[
        if (textLabel != null) Expanded(child: Text(textLabel)),
        ...dataList.map(
          (e) => Row(
            children: [
              Radio(
                value: e,
                groupValue: group,
                onChanged: onChanged,
              ),
              title(e),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget dropdown<T>({
    T? value,
    List<DropdownMenuItem<T>>? items,
    Function(T?)? onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      style: Get.textTheme.headline1!.copyWith(fontSize: 9.sp, color: Colors.deepPurple),
      icon: Icon(
        Icons.arrow_drop_down,
        color: Colors.deepPurple,
        size: 20.sp,
      ),
      decoration: InputDecoration(
        fillColor: Colors.grey.shade200,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
              width: 0,
            )),
        contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      ),
      onChanged: onChanged,
    );
  }

  static Widget button(
      {Key? key, required Color color, required double width, required String title, required Function()? func}) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(vertical: 0.1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: color,
      ),
      child: MaterialButton(
        onPressed: func,
        child: Text(
          title,
          style: Get.textTheme.headline1?.copyWith(fontSize: 11.sp, color: Appcolors.white),
        ),
      ),
    );
  }
}
