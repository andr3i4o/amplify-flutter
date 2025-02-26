/*
 * Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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

package com.amazonaws.amplify.amplify_datastore.types.hub

import com.amazonaws.amplify.amplify_datastore.types.model.FlutterSerializedModel
import com.amplifyframework.core.model.SerializedModel
import com.amplifyframework.datastore.appsync.ModelMetadata

class FlutterSubscriptionDataProcessedEvent(
    override val eventName: String,
    private val model: SerializedModel,
    private val syncMetadata: ModelMetadata,
) : FlutterHubEvent {
    override fun toValueMap(): Map<String, Any> {
        return mapOf(
            "eventName" to eventName,
            "modelName" to model.modelName,
            "element" to mapOf(
                "syncMetadata" to mapOf(
                    "_deleted" to syncMetadata.isDeleted,
                    "_version" to syncMetadata.version,
                    "_lastChangedAt" to syncMetadata.lastChangedAt?.secondsSinceEpoch
                ),
                "model" to FlutterSerializedModel(model).toMap()
            )
        )
    }
}
