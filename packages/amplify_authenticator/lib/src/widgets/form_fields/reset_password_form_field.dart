/*
 * Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
*/

part of authenticator.form_field;

/// {@category Prebuilt Widgets}
/// {@template amplify_authenticator.confirm_sign_up_form_field}
/// A prebuild form field widget for use on the Reset Password Step.
/// {@endtemplate}
class ResetPasswordFormField extends AuthenticatorFormField<ResetPasswordField,
    String, ResetPasswordFormField> {
  /// {@macro amplify_authenticator.sign_up_form_field}
  ///
  /// Either [titleKey] or [title] is required.
  const ResetPasswordFormField._({
    Key? key,
    required ResetPasswordField field,
    InputResolverKey? titleKey,
    InputResolverKey? hintTextKey,
    FormFieldValidator<String>? validator,
  }) : super._(
          key: key,
          field: field,
          titleKey: titleKey,
          hintTextKey: hintTextKey,
          validator: validator,
        );

  const ResetPasswordFormField.verificationCode({
    Key? key,
  }) : this._(
          key: key ?? keyVerificationCodeResetPasswordFormField,
          field: ResetPasswordField.verificationCode,
          titleKey: InputResolverKey.verificationCodeTitle,
          hintTextKey: InputResolverKey.verificationCodeHint,
        );

  const ResetPasswordFormField.newPassword({
    Key? key,
    FormFieldValidator<String>? validator,
  }) : this._(
          key: key ?? keyPasswordResetPasswordFormField,
          field: ResetPasswordField.newPassword,
          titleKey: InputResolverKey.newPasswordTitle,
          hintTextKey: InputResolverKey.newPasswordHint,
          validator: validator,
        );

  const ResetPasswordFormField.passwordConfirmation({
    Key? key,
  }) : this._(
          key: key ?? keyPasswordConfirmationResetPasswordFormField,
          field: ResetPasswordField.passwordConfirmation,
          titleKey: InputResolverKey.passwordConfirmationTitle,
          hintTextKey: InputResolverKey.passwordConfirmationHint,
        );

  @override
  bool get required => true;

  @override
  AuthenticatorComponentState<ResetPasswordFormField> createState() =>
      _ResetPasswordFormFieldState();
}

class _ResetPasswordFormFieldState extends AuthenticatorFormFieldState<
    ResetPasswordField,
    String,
    ResetPasswordFormField> with AuthenticatorTextField {
  @override
  bool get obscureText {
    switch (widget.field) {
      case ResetPasswordField.newPassword:
      case ResetPasswordField.passwordConfirmation:
        return true;
      case ResetPasswordField.verificationCode:
        return false;
    }
  }

  @override
  TextInputType get keyboardType {
    switch (widget.field) {
      case ResetPasswordField.newPassword:
      case ResetPasswordField.passwordConfirmation:
        return TextInputType.visiblePassword;
      case ResetPasswordField.verificationCode:
        return TextInputType.number;
    }
  }

  @override
  Widget? get suffix {
    switch (widget.field) {
      case ResetPasswordField.newPassword:
      case ResetPasswordField.passwordConfirmation:
        return visibilityToggle;
      default:
        return null;
    }
  }

  @override
  int get errorMaxLines {
    switch (widget.field) {
      case ResetPasswordField.newPassword:
        return 6;
      default:
        return super.errorMaxLines;
    }
  }

  @override
  String? get initialValue {
    switch (widget.field) {
      case ResetPasswordField.newPassword:
        return state.newPassword;
      case ResetPasswordField.verificationCode:
        return state.confirmationCode;
      case ResetPasswordField.passwordConfirmation:
        return super.initialValue;
    }
  }

  @override
  ValueChanged<String> get onChanged {
    switch (widget.field) {
      case ResetPasswordField.newPassword:
        return (v) => state.newPassword = v;
      case ResetPasswordField.verificationCode:
        return (v) => state.confirmationCode = v;
      case ResetPasswordField.passwordConfirmation:
        return super.onChanged;
    }
  }

  @override
  FormFieldValidator<String> get validator {
    switch (widget.field) {
      case ResetPasswordField.newPassword:
        return validateNewPassword(
          amplifyConfig: config.amplifyConfig,
          inputResolver: stringResolver.inputs,
        )(context);
      case ResetPasswordField.passwordConfirmation:
        return validatePasswordConfirmation(
          () => state.newPassword,
          context: context,
          inputResolver: stringResolver.inputs,
        );
      case ResetPasswordField.verificationCode:
        return validateCode(
          isOptional: isOptional,
          context: context,
          inputResolver: stringResolver.inputs,
        );
    }
  }
}
