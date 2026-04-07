#include "ncpch.h"
#include "LayerStack.h"

namespace Nutcracker {

    LayerStack::LayerStack()
    {
        m_LayerInsert = m_Layers.begin();
    }

    LayerStack::~LayerStack()
    {
        for (Layer* layer : m_Layers)
            delete layer;
    }

    void LayerStack::PushLayer(Layer* layer)
    {
        m_LayerInsert = m_Layers.emplace(m_LayerInsert, layer);
    }

    void LayerStack::PushOverlay(Layer* overlay)
    {
        m_Layers.emplace(m_LayerInsert, overlay);
        // emplace() 是直接在容器为其分配的内存上构造元素，省去了创建和销毁临时对象的开销
        // 此处的 emplace() 是在指定位置前插入，还有 emplace_back() 是专门在容器尾部插入
    }

    void LayerStack::PopLayer(Layer* layer)
    {
        auto it = std::find(m_Layers.begin(), m_Layers.end(), layer);
        if (it != m_Layers.end())
        {
            m_Layers.erase(it);
            m_LayerInsert--; // 这对吗？m_LayerInsert保存的应该是最后push进来的layer，但查找到的layer可能位于任何位置
        }
    }

    void LayerStack::PopOverlay(Layer* overlay)
    {
        auto it = std::find(m_Layers.begin(), m_Layers.end(), overlay);
        if (it != m_Layers.end())
            m_Layers.erase(it);
    }

}
